from SCons.Script import *

import os.path
import glob
import winreg
import urllib.request
import zipfile

env = Environment(tools=[])
addonsFolder = r"@AH-64D Apache Longbow\Addons"
pbos = ["fza_ah64_AICrew", "fza_ah64_controls", "fza_ah64_sfmplus", "fza_ah64_ku", "fza_ah64_mpd", "fza_ah64_ufd", "fza_ah64_us", "fza_ah64_dms"]
linkablePbos = ["fza_ah64_AICrew", "fza_ah64_controls", "fza_ah64_sfmplus", "fza_ah64_ku", "fza_ah64_mpd", "fza_ah64_ufd", "fza_ah64_dms"]

def targetDef(target, description):
    return env.Help(f"\n{target.ljust(20)}\t - {description}")

def allFilesIn(path):
    return [s.replace("$", "$$") for s in glob.glob(path + '/**/*', recursive=True) if os.path.isfile(s)]

def a3toolsPath():
    with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"SOFTWARE\Bohemia Interactive\Arma 3 Tools") as key:
        return winreg.QueryValueEx(key, "path")[0]

def arma3Path():
    reg = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
    with winreg.OpenKey(reg, r"SOFTWARE\Wow6432Node\bohemia interactive\arma 3") as key:
        return winreg.EnumValue(key,1)[1]

def addonBuilderPath():
    return os.path.join(a3toolsPath(), "AddonBuilder", "AddonBuilder.exe")

def buildPbo(env, pbo):
    target = os.path.join(addonsFolder, pbo)
    outputPbo = os.path.join(addonsFolder, pbo + ".pbo")
    inputFolder = target
    env.Command(outputPbo, allFilesIn(inputFolder), 
        f'"{addonBuilderPath()}" "{os.path.abspath(inputFolder)}" "{os.path.abspath(addonsFolder)}" -clear -include=buildExtIncludes.txt')
    targetDef(pbo, f"Build the {pbo} pbo.")
    return env.Alias(pbo, outputPbo)

pboAliases = [buildPbo(env, pbo) for pbo in pbos]

env.Command("buildTools", [], Mkdir("buildTools"))

def downloadNaturaldocs(target, source, env):
    url = "https://www.naturaldocs.org/download/natural_docs/2.1.1/Natural_Docs_2.1.1.zip"
    zipFilePath = r"buildTools\NaturalDocs.zip"
    urllib.request.urlretrieve(url, zipFilePath)
    with zipfile.ZipFile(zipFilePath, 'r') as zip_ref:
        zip_ref.extractall(r"buildTools")
    
env.Command(r"buildTools\Natural Docs", [], [downloadNaturaldocs, Delete(r"buildTools\NaturalDocs.zip")])

allPbos = env.Alias("all", pboAliases)
targetDef("all", "Build all pbos.")

env.Command(r"docs\index.html",
    [s for s in allFilesIn(addonsFolder) if s.endswith(".sqf")] + [r"buildTools\Natural Docs"], 
    [Mkdir("docs"), r'"buildTools\Natural Docs\NaturalDocs.exe" naturaldocs'])

env.Alias("docs", r"docs\index.html")
targetDef("docs", "Generate naturaldocs documentation")
env.Help("\n")

env.Clean(["buildTools", "all"], r"buildTools")
env.Clean(["docs", "all"], ["docs", r"naturaldocs\Working Data"])


try:
    a3dir = arma3Path()
    symlinks = env.Alias("symlinks", [], [f'mklink /J "{os.path.join(a3dir, pbo)}" "{os.path.join(addonsFolder, pbo)}"' for pbo in linkablePbos])
    env.AlwaysBuild(symlinks)

    removeSymlinks = env.Alias("rmsymlinks", [], [f'fsutil reparsepoint delete "{os.path.join(a3dir, pbo)}"' for pbo in linkablePbos] + [Delete(os.path.join(a3dir, pbo)) for pbo in linkablePbos])
    env.AlwaysBuild(removeSymlinks)
except:
    print("Error: Couldn't find arma 3, cannot make or remove symlinks")

env.Default("all")