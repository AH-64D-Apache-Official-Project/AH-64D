from SCons.Script import *

import os.path
import glob
import winreg
import urllib.request
import os
import zipfile
import json
import subprocess
import tools.mfd_documentation.document as mfd_document

env = Environment(tools=[])

# Utility functions
def currentCommitHash():
    commit = subprocess.run(["git", "rev-parse", "--short", "HEAD"], capture_output=True, check=True)
    return commit.stdout.decode('ascii').strip()

def allFilesIn(path):
    return [s.replace("$", "$$") for s in glob.glob(path + '/**/*', recursive=True) if os.path.isfile(s)]

def getSettings():
    with open("build.json") as file:
        settings = json.load(file)

    # Prefer configured addons folder, but fall back to the repo-local
    # `addons` folder when legacy @mod paths are missing.
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

def setupAddonsDirectory():
    """Create addons/ directory with copies of all addons for HEMTT."""
    addons_root = os.path.join(getSettings()["addonsFolder"])
    addons_link = "addons"
    
    # Create addons directory if it doesn't exist
    os.makedirs(addons_link, exist_ok=True)
    
    # Get all addon folders
    addon_folders = [d for d in os.listdir(addons_root) 
                     if os.path.isdir(os.path.join(addons_root, d))]
    
    # Copy each addon using xcopy (preserves structure)
    for addon in addon_folders:
        source = os.path.join(addons_root, addon)
        target = os.path.join(addons_link, addon)
        
        # Skip if already up to date
        if os.path.isdir(target):
            continue
        
        # Copy using xcopy
        subprocess.run(
            ["xcopy", source, target, "/E", "/I", "/Y"],
            capture_output=True
        )

def targetDefinition(target, description):
    return env.Help(f"\n{target.ljust(20)}\t - {description}")

def isJunction(path):
    process = subprocess.run(["fsutil", "reparsepoint", "query", path], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return process.returncode == 0

# Useful paths
def a3toolsPath():
    with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"SOFTWARE\Bohemia Interactive\Arma 3 Tools") as key:
        return winreg.QueryValueEx(key, "path")[0]

def arma3Path():
    reg = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
    with winreg.OpenKey(reg, r"SOFTWARE\Wow6432Node\bohemia interactive\arma 3") as key:
        return winreg.EnumValue(key,1)[1]

def addonBuilderPath():
    return os.path.join(a3toolsPath(), "AddonBuilder", "AddonBuilder.exe")

def hemttPath():
    result = subprocess.run(["where", "hemtt"], capture_output=True)
    if result.returncode == 0:
        return result.stdout.decode('ascii').strip().split('\n')[0]
    
    # Fallback locations
    fallback_paths = [
        r"C:\Program Files\hemtt\hemtt.exe",
        r"C:\Program Files (x86)\hemtt\hemtt.exe",
        os.path.expandvars(r"%APPDATA%\.cargo\bin\hemtt.exe"),
    ]
    for path in fallback_paths:
        if os.path.isfile(path):
            return path
    
    raise FileNotFoundError("HEMTT not found. Please install HEMTT from https://hemtt.dev/")

class Object(object):
    pass

def getPboInfo(settings):
    def addInfo(name):
        pboInfo = Object()
        pboInfo.name = name
        pboInfo.folder = os.path.join(settings["addonsFolder"], name)
        pboInfo.outputPath = pboInfo.folder + ".pbo"
        with open(os.path.join(pboInfo.folder,"$PBOPREFIX$"), "r") as file:
            pboInfo.pboPrefix = file.readline().strip()
        try:
            pboInfo.a3symlink = os.path.join(arma3Path(),pboInfo.pboPrefix)
        except:
            pboInfo.a3symlink = None
        pboInfo.buildSymlink = os.path.join("build",pboInfo.pboPrefix)

        if (name in settings["excludePboSymlinks"]):
            pboInfo.a3symlink = None
        return pboInfo
    return list(map(addInfo,filter(lambda x: os.path.isdir(os.path.join(settings["addonsFolder"], x)), os.listdir(settings["addonsFolder"]))))

# Build target functions
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

def removeSymlink(pathTo):
    if pathTo is None:
        return []
    commands = []
    if isJunction(pathTo):
        commands.append(f'fsutil reparsepoint delete \"{pathTo}\"')
    if os.path.isdir(pathTo):
        commands.append(Delete(pathTo))
    return commands

def buildSymlink(pathFrom, pathTo):
    if pathTo is None:
        return []
    commands = removeSymlink(pathTo)
    if not os.path.isdir(os.path.dirname(pathTo)):
        commands.append(Mkdir(os.path.dirname(pathTo)))
    commands.append(f'mklink /J "{pathTo}" "{pathFrom}"')
    return commands

def buildPbo(settings,pbos,env, pbo):
    commit = currentCommitHash()
    with open(os.path.join(pbo.folder, "version.hpp"), 'w') as f:
        f.write(f"hash = \"{commit}\";\n")
        f.write("pbos[] = {\""+ "\", \"".join(map(lambda pbo: pbo.name, pbos)) + "\"};\n")
    
    # Return path - HEMPT handles all builds in one call
    targetDefinition(pbo.name, f"Build the {pbo.name} pbo.")
    return pbo.outputPath

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
    args.filepath = None
    mfd_document.run(args)

settings = getSettings()
pbos = getPboInfo(settings)

pboAliases = [buildPbo(settings,pbos,env, pbo) for pbo in pbos]

env.Command("buildTools", [], Mkdir("buildTools"))
    
buildDir = env.Command("build", allFilesIn("include"), [Copy("build", "include")] + sum(map(lambda pbo: buildSymlink(pbo.folder, pbo.buildSymlink),pbos),[]))

env.Command(r"buildTools\Natural Docs", [], [downloadNaturaldocs, Delete(r"buildTools\NaturalDocs.zip")])

# Build all PBOs using HEMPT (single call builds all addons)
hemtt_exe = hemttPath()
hemttBuild = env.Command(pboAliases, ["build"], f'"{hemtt_exe}" build')

allPbos = env.Alias("all", [hemttBuild])
targetDefinition("all", "Build all pbos.")

buildDocs = env.Command(r"docs\index.html",
    [s for s in allFilesIn(settings["addonsFolder"]) if s.endswith(".sqf")] + [r"buildTools\Natural Docs"], 
    [Mkdir("docs"), r'"buildTools\Natural Docs\NaturalDocs.exe" naturaldocs', generateMfdDocumentation])
env.AlwaysBuild(buildDocs)

env.Alias("docs", r"docs\index.html")
targetDefinition("docs", "Generate naturaldocs documentation")
env.Help("\n")

env.Clean(["buildTools", "all"], r"buildTools")
env.Clean(["docs", "all"], ["docs", r"naturaldocs\Working Data"])

try:
    settings = getSettings()
    a3dir = arma3Path()
    symlinks = env.Alias("symlinks", [], sum(map(commandsToCreateSymlink, pbos),[]))
    env.AlwaysBuild(symlinks)

    removeSymlinks = env.Alias("rmsymlinks", [], sum(map(commandsToRemoveSymlink, pbos),[]))
    env.AlwaysBuild(removeSymlinks)
except Exception as e:
    print(e)
    print("Error: Couldn't find arma 3, cannot make or remove symlinks")

env.Default("all")