from SCons.Script import *

import os.path
import glob
import winreg
import urllib.request
import os
import zipfile
import json
import subprocess
import tempfile
import tools.mfd_documentation.document as mfd_document

env = Environment(tools=[])

# Utility functions
def allFilesIn(path):
    return [s.replace("$", "$$") for s in glob.glob(path + '/**/*', recursive=True) if os.path.isfile(s)]

def getSettings():
    with open("tools/build.json") as file:
        settings = json.load(file)

    addons_folder = settings.get("addonsFolder", "addons")
    if not os.path.isdir(addons_folder):
        fallback = "addons"
        if os.path.isdir(fallback):
            print(f"Warning: addonsFolder '{addons_folder}' not found; using '{fallback}'")
            settings["addonsFolder"] = fallback
        else:
            raise FileNotFoundError(
                f"Configured addonsFolder '{addons_folder}' does not exist, and fallback '{fallback}' is missing."
            )

    return settings

def targetDefinition(target, description):
    return env.Help(f"\n{target.ljust(20)}\t - {description}")

def isJunction(path):
    process = subprocess.run(["fsutil", "reparsepoint", "query", path], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return process.returncode == 0

# Useful paths
def hemttPath():
    result = subprocess.run(["where", "hemtt"], capture_output=True)
    if result.returncode == 0:
        return result.stdout.decode('utf-8').splitlines()[0].strip()
    raise FileNotFoundError("HEMTT not found on PATH. Install from https://hemtt.dev/")

def arma3Path():
    reg = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
    with winreg.OpenKey(reg, r"SOFTWARE\Wow6432Node\bohemia interactive\arma 3") as key:
        return winreg.EnumValue(key,1)[1]

def arma3ToolsPath():
    """Find Arma 3 Tools installation directory."""
    # Primary: AddonBuilder registers its own path under Bohemia Interactive
    try:
        reg = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
        with winreg.OpenKey(reg, r"SOFTWARE\Wow6432Node\Bohemia Interactive\AddonBuilder") as key:
            addon_builder_path = winreg.QueryValueEx(key, "path")[0]
            tools = os.path.dirname(addon_builder_path)
            if os.path.isdir(tools):
                return tools
    except Exception:
        pass
    # Fallback: look in the same Steam library folder as Arma 3
    try:
        candidate = os.path.join(os.path.dirname(arma3Path()), "Arma 3 Tools")
        if os.path.isdir(candidate):
            return candidate
    except Exception:
        pass
    raise FileNotFoundError(
        "Arma 3 Tools not found. Install via Steam (App ID 233800)."
    )

def readPboPrefix(addon_dir_path):
    """Return the PBO prefix for an addon from its $PBOPREFIX$ file."""
    prefix_file = os.path.join(addon_dir_path, "$PBOPREFIX$")
    if os.path.isfile(prefix_file):
        with open(prefix_file, "r") as f:
            return f.readline().strip()
    return os.path.basename(addon_dir_path)

def findAddonsWithRapifyDisabled():
    """Return sorted list of addon folder names where [rapify] enabled = false."""
    result = []
    for name in sorted(os.listdir("addons")):
        toml_path = os.path.join("addons", name, "addon.toml")
        if not os.path.isfile(toml_path):
            continue
        with open(toml_path, "r") as f:
            lines = f.readlines()
        in_rapify = False
        for line in lines:
            stripped = line.strip()
            if stripped == "[rapify]":
                in_rapify = True
            elif stripped.startswith("[") and in_rapify:
                in_rapify = False
            elif in_rapify and stripped == "enabled = false":
                result.append(name)
                break
    return result

# Mutable container so setupSourceDrive/teardownSourceDrive can share state
_pdrive_state = {"temp_dir": None}

def setupSourceDrive(drive="P"):
    """
    Create a temp directory with junction points for every addon (by PBO prefix)
    and every include directory, then map it as <drive>: using subst.
    This lets CfgConvert resolve absolute Arma paths like \\x\\cba\\... or
    \\fza_ah64_controls\\... when binarizing a config.
    """
    if os.path.exists(f"{drive}:\\"):
        raise RuntimeError(
            f"Drive {drive}: is already in use. Free it before building, "
            f"or change the drive letter passed to setupSourceDrive()."
        )

    temp_dir = tempfile.mkdtemp(prefix="hemtt_pdrive_")
    _pdrive_state["temp_dir"] = temp_dir
    _pdrive_state["drive"] = drive

    def junction(link, target):
        if not os.path.exists(link):
            subprocess.run(
                f'mklink /J "{link}" "{target}"',
                shell=True, check=True,
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            )

    # Map each addon under its PBO prefix  (e.g. P:\fza_ah64_mpd\)
    for name in os.listdir("addons"):
        addon_path = os.path.abspath(os.path.join("addons", name))
        if not os.path.isdir(addon_path):
            continue
        prefix = readPboPrefix(addon_path)
        junction(os.path.join(temp_dir, prefix), addon_path)

    # Map include directories  (x/ → CBA, z/ → ACE, a3/ → Arma 3 headers)
    include_root = os.path.abspath("include")
    if os.path.isdir(include_root):
        for inc_name in os.listdir(include_root):
            inc_path = os.path.join(include_root, inc_name)
            if os.path.isdir(inc_path):
                junction(os.path.join(temp_dir, inc_name), inc_path)

    result = subprocess.run(
        f'subst {drive}: "{temp_dir}"',
        shell=True, capture_output=True,
    )
    if result.returncode != 0:
        teardownSourceDrive()
        raise RuntimeError(
            f"subst {drive}: failed: {result.stderr.decode().strip()}"
        )

def teardownSourceDrive():
    """Remove the subst drive mapping and clean up the junction directory."""
    drive = _pdrive_state.get("drive", "P")
    temp_dir = _pdrive_state.get("temp_dir")

    subprocess.run(
        f"subst {drive}: /D", shell=True,
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
    )

    if temp_dir and os.path.isdir(temp_dir):
        for item in os.listdir(temp_dir):
            link = os.path.join(temp_dir, item)
            subprocess.run(
                f'fsutil reparsepoint delete "{link}"',
                shell=True,
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            )
            if os.path.isdir(link):
                try:
                    os.rmdir(link)
                except OSError:
                    pass
        try:
            os.rmdir(temp_dir)
        except OSError:
            pass
    _pdrive_state["temp_dir"] = None
    _pdrive_state["drive"] = None

def preBinarizeConfigs(target, source, env):
    """
    SCons action: for each addon that has [rapify] enabled = false, run
    CfgConvert.exe -bin to produce a config.bin in the addon source folder.
    HEMTT will then pack config.bin alongside config.cpp; Arma prefers .bin.
    """
    addons = findAddonsWithRapifyDisabled()
    if not addons:
        return 0

    try:
        tools = arma3ToolsPath()
    except FileNotFoundError as e:
        print(f"Warning: {e}")
        print("Warning: Arma 3 Tools must be installed to binarize configs.")
        print("Warning: Install 'Arma 3 Tools' via Steam (App ID 233800) and re-run.")
        print("Warning: Skipping config pre-binarization.")
        return 0

    cfgconvert = os.path.join(tools, "CfgConvert", "CfgConvert.exe")
    if not os.path.isfile(cfgconvert):
        print(f"Warning: CfgConvert.exe not found at expected path: {cfgconvert}")
        print("Warning: CfgConvert is part of Arma 3 Tools — ensure it is fully installed via Steam (App ID 233800).")
        print("Warning: Skipping config pre-binarization.")
        return 0

    try:
        setupSourceDrive()
    except RuntimeError as e:
        print(f"Warning: {e} — skipping config pre-binarization.")
        return 0

    exit_code = 0
    drive = _pdrive_state["drive"]
    # CfgConvert resolves leading-backslash includes (e.g. \x\cba\...) by
    # stripping the backslash and searching relative to the working directory.
    # Setting cwd to the drive root makes those paths resolve correctly.
    drive_root = drive + ":\\"
    try:
        for addon_name in addons:
            addon_path = os.path.abspath(os.path.join("addons", addon_name))
            prefix = readPboPrefix(addon_path)
            src = f"{drive}:\\{prefix}\\config.cpp"
            dst = os.path.join(addon_path, "config.bin")

            print(f"Pre-binarizing config: {addon_name}...")
            proc = subprocess.run(
                [cfgconvert, "-bin", "-dst", dst, src],
                capture_output=True, text=True,
                cwd=drive_root,
            )
            if proc.returncode != 0 or not os.path.isfile(dst):
                print(f"  ERROR: CfgConvert failed for {addon_name}")
                output = (proc.stderr + proc.stdout).strip()
                if output:
                    for line in output.splitlines():
                        if line.strip():
                            print(f"    {line}")
                else:
                    print(f"    (no output from CfgConvert - it may have crashed)")
                    print(f"    Ensure AddonBuilder.exe has been run at least once after installing Arma 3 Tools.")
                    print(f"    Open Arma 3 Tools from Steam, launch AddonBuilder, then retry the build.")
                exit_code = 1
            else:
                print(f"  OK ({os.path.getsize(dst):,} bytes) -> {dst}")
    finally:
        teardownSourceDrive()

    return exit_code

def cleanupBinarizedConfigs(target, source, env):
    """SCons action: remove config.bin files written by preBinarizeConfigs."""
    for addon_name in findAddonsWithRapifyDisabled():
        dst = os.path.join("addons", addon_name, "config.bin")
        if os.path.isfile(dst):
            os.remove(dst)
            print(f"Removed stale config.bin: {addon_name}")
    return 0

class Object(object):
    pass

def getPboInfo(settings):
    def addInfo(name):
        pboInfo = Object()
        pboInfo.name = name
        pboInfo.folder = os.path.join(settings["addonsFolder"], name)
        with open(os.path.join(pboInfo.folder,"$PBOPREFIX$"), "r") as file:
            pboInfo.pboPrefix = file.readline().strip()
        try:
            pboInfo.a3symlink = os.path.join(arma3Path(),pboInfo.pboPrefix)
        except:
            pboInfo.a3symlink = None

        if (name in settings["excludePboSymlinks"]):
            pboInfo.a3symlink = None
        return pboInfo
    return list(map(addInfo,filter(lambda x: os.path.isdir(os.path.join(settings["addonsFolder"], x)), os.listdir(settings["addonsFolder"]))))

# Symlink management for file patching
def commandsToRemoveSymlink(pbo):
    if pbo.a3symlink is None:
        return []
    commands = []
    if isJunction(pbo.a3symlink):
        commands.append(f'fsutil reparsepoint delete \"{pbo.a3symlink}\"')
    if os.path.isdir(pbo.a3symlink):
        commands.append(Delete(pbo.a3symlink))
    return commands

def commandsToCreateSymlink(pbo):
    if pbo.a3symlink is None:
        return []
    commands = commandsToRemoveSymlink(pbo)
    if not os.path.isdir(os.path.dirname(pbo.a3symlink)):
        commands.append(Mkdir(os.path.dirname(pbo.a3symlink)))
    commands.append(f'mklink /J "{pbo.a3symlink}" "{pbo.folder}"')
    return commands

# Documentation
def downloadNaturaldocs(target, source, env):
    url = "https://www.naturaldocs.org/download/natural_docs/2.2/Natural_Docs_2.2.zip"
    zipFilePath = r"buildTools\NaturalDocs.zip"
    urllib.request.urlretrieve(url, zipFilePath)
    with zipfile.ZipFile(zipFilePath, 'r') as zip_ref:
        zip_ref.extractall(r"buildTools")

def generateMfdDocumentation(target, source, env):
    class Namespace:
        pass
    args = Namespace()
    args.output = "docs/other/mfdindices.html"
    args.filepath = os.path.join("addons", "fza_ah64_mpd", "headers", "mfdConstants.h")
    mfd_document.run(args)

settings = getSettings()
pbos = getPboInfo(settings)

env.Command("buildTools", [], Mkdir("buildTools"))

env.Command(r"buildTools\Natural Docs", [], [downloadNaturaldocs, Delete(r"buildTools\NaturalDocs.zip")])

# Build all PBOs using HEMTT (version.hpp generated by .hemtt/hooks/pre_build/version_files.rhai)
# When building via SCons, config.cpp is pre-binarized with CfgConvert for any addon
# that has rapify disabled, the resulting config.bin is packed by HEMTT, and then
# cleaned up afterwards so standalone `hemtt build` never sees a stale config.bin.
hemtt_exe = hemttPath()

def _hemttBuildAction(target, source, env):
    """Pre-binarize configs → hemtt build → remove binarized configs."""
    preBinarizeConfigs(target, source, env)
    try:
        result = subprocess.run([hemtt_exe, "build"])
        return result.returncode
    finally:
        cleanupBinarizedConfigs(target, source, env)

def _repackageReleaseZips():
    """
    Repackage release zips to rename the inner mod folder:
      - Inner folder: @fza_ah64  ->  @fza_ah64_apache_longbow
    The zip file rename (fza_ah64-*.zip -> ah64-*.zip) is handled by the
    HEMTT post_release hook (.hemtt/hooks/post_release/rename_zips.rhai)
    which runs as part of `hemtt release` before this function is called.
    """
    releases_dir = os.path.abspath("releases")
    old_folder = "@fza_ah64"
    new_folder = "@fza_ah64_apache_longbow"

    zips = glob.glob(os.path.join(releases_dir, "ah64-*.zip"))
    if not zips:
        print("No ah64-*.zip files found in releases/ — skipping inner folder repackage.")
        return

    for zip_path in zips:
        zip_name = os.path.basename(zip_path)
        temp_dir = os.path.join(releases_dir, "_repack_temp")
        if os.path.isdir(temp_dir):
            import shutil
            shutil.rmtree(temp_dir)

        print(f"Repackaging {zip_name} (renaming inner folder)...")
        with zipfile.ZipFile(zip_path, "r") as zf:
            zf.extractall(temp_dir)

        old_path = os.path.join(temp_dir, old_folder)
        if os.path.isdir(old_path):
            os.rename(old_path, os.path.join(temp_dir, new_folder))

        if os.path.isfile(zip_path):
            os.remove(zip_path)

        with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
            for root, dirs, files in os.walk(temp_dir):
                for file in files:
                    abs_path = os.path.join(root, file)
                    arc_name = os.path.relpath(abs_path, temp_dir)
                    zf.write(abs_path, arc_name)

        import shutil
        shutil.rmtree(temp_dir)
        print(f"  -> {zip_name} ({new_folder})")

def _hemttReleaseAction(target, source, env):
    """Pre-binarize configs → hemtt release → repackage zips → remove binarized configs."""
    preBinarizeConfigs(target, source, env)
    try:
        result = subprocess.run([hemtt_exe, "release"])
        if result.returncode != 0:
            return result.returncode
        _repackageReleaseZips()
        return 0
    finally:
        cleanupBinarizedConfigs(target, source, env)

hemttBuild = env.Command(
    ".hemttout",
    allFilesIn("addons"),
    [Action(_hemttBuildAction, f'"{hemtt_exe}" build')],
)
env.AlwaysBuild(hemttBuild)

hemttRelease = env.Command(
    "releases",
    allFilesIn("addons"),
    [Action(_hemttReleaseAction, f'"{hemtt_exe}" release')],
)
env.AlwaysBuild(hemttRelease)

allPbos = env.Alias("all", [hemttBuild])
targetDefinition("all", "Build all pbos via HEMTT.")

env.Alias("release", [hemttRelease])
targetDefinition("release", "Release via HEMTT with config pre-binarization (signs, archives).")

buildMfdDocs = env.Command(r"docs\other\mfdindices.html",
    [os.path.join("addons", "fza_ah64_mpd", "headers", "mfdConstants.h")],
    generateMfdDocumentation)
env.AlwaysBuild(buildMfdDocs)

buildDocs = env.Command(r"docs\index.html",
    [s for s in allFilesIn(settings["addonsFolder"]) if s.endswith(".sqf")] + [r"buildTools\Natural Docs"], 
    [Mkdir("docs"), r'"buildTools\Natural Docs\NaturalDocs.exe" naturaldocs'])
env.AlwaysBuild(buildDocs)

env.Alias("docs", [r"docs\index.html", r"docs\other\mfdindices.html"])
targetDefinition("docs", "Generate naturaldocs documentation")
env.Help("\n")
targetDefinition("-c / --clean", "Clean build outputs (.hemttout, releases, docs, buildTools).")
targetDefinition("-c release", "Clean release outputs only (.hemttout, releases).")

env.Clean(["buildTools", "all"], r"buildTools")
env.Clean(["docs", "all"], ["docs", r"naturaldocs\Working Data"])
env.Clean(["all", "release"], [".hemttout", "releases"])

try:
    settings = getSettings()
    a3dir = arma3Path()
    symlinks = env.Alias("symlinks", [], sum(map(commandsToCreateSymlink, pbos),[]))
    env.AlwaysBuild(symlinks)
    env.Help("\n")
    targetDefinition("symlinks", "Create Arma 3 junction links for each addon (enables file patching).")

    removeSymlinks = env.Alias("rmsymlinks", [], sum(map(commandsToRemoveSymlink, pbos),[]))
    env.AlwaysBuild(removeSymlinks)
    targetDefinition("rmsymlinks", "Remove Arma 3 junction links.")
    env.Help("\n")
except Exception as e:
    print(e)
    print("Error: Couldn't find arma 3, cannot make or remove symlinks")

env.Default("all")