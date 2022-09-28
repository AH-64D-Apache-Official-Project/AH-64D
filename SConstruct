from SCons.Script import *

import os.path
import glob
import winreg
import urllib.request
import os
import zipfile
import json
import subprocess

env = Environment(tools=[])

# Utility functions

def allFilesIn(path):
    return [s.replace("$", "$$") for s in glob.glob(path + '/**/*', recursive=True) if os.path.isfile(s)]

def getSettings():
    with open("build.json") as file:
        return json.load(file)

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

def buildPbo(settings,env, pbo):
    env.Command(pbo.outputPath, allFilesIn(pbo.folder), 
        f'"{addonBuilderPath()}" "{os.path.abspath(pbo.folder)}" "{os.path.abspath(settings["addonsFolder"])}" -clear -include=buildExtIncludes.txt')
    targetDefinition(pbo.name, f"Build the {pbo.name} pbo.")
    return env.Alias(pbo.name, pbo.outputPath)

def downloadNaturaldocs(target, source, env):
    url = "https://www.naturaldocs.org/download/natural_docs/2.1.1/Natural_Docs_2.1.1.zip"
    zipFilePath = r"buildTools\NaturalDocs.zip"
    urllib.request.urlretrieve(url, zipFilePath)
    with zipfile.ZipFile(zipFilePath, 'r') as zip_ref:
        zip_ref.extractall(r"buildTools")

settings = getSettings()
pbos = getPboInfo(settings)

pboAliases = [buildPbo(settings,env, pbo) for pbo in pbos]

env.Command("buildTools", [], Mkdir("buildTools"))
    
env.Command(r"buildTools\Natural Docs", [], [downloadNaturaldocs, Delete(r"buildTools\NaturalDocs.zip")])

allPbos = env.Alias("all", pboAliases)
targetDefinition("all", "Build all pbos.")

buildDocs = env.Command(r"docs\index.html",
    [s for s in allFilesIn(settings["addonsFolder"]) if s.endswith(".sqf")] + [r"buildTools\Natural Docs"], 
    [Mkdir("docs"), r'"buildTools\Natural Docs\NaturalDocs.exe" naturaldocs'])
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