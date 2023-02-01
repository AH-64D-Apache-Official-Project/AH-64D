# Checks that all files within the mod folder (@AH-64D Apache Longbow/Addons/fza_ah64_us) match the
# file conventions, as defined by regex

import subprocess
import os
import argparse
import re
import yaml
import sys

#A valid PBO file name must start with "fza_ah64_" and then be all lower case letters
reValidPboName = re.compile(r'^fza_ah64_[a-z]+$')
# A valid folder name must start with lower case, and then be any
reValidFolderName = re.compile(r'^[a-z0-9][a-zA-Z0-9]*(_[a-z0-9][a-zA-Z0-9]*)*$')
reValidFileName = re.compile(r'^[a-z0-9][a-zA-Z0-9]*(_[a-z0-9][a-zA-Z0-9]*)*\.[a-z]+$')
reValidConfigName = re.compile(r'(Cfg|Fza|Rsc)[A-Z][a-z0-9A-Z]*\.hpp')

def listPrefix(pref,val):
    if (len(val) < len(pref)):
        return False
    return all(map(lambda x: x[0] == x[1], zip(pref, val)))

class FilePathValidator:
    def __init__(self, ignorePaths=None, ignoreFileNames=None):
        self.errors = []
        self.ignoreFileNames = ignoreFileNames
        self.ignorePaths = list(map(lambda x: x.split("/"), ignorePaths))

    def fileError(self, filePath, message):
        self.errors.append(f"{filePath}: {message}")

    def validateFilePath(self, path):
        splitPath = os.path.normpath(path).split(os.sep)
        if (list(map(lambda x: x.lower(), splitPath[0:2])) != ['@ah-64d apache longbow', 'addons']):
            return
        if splitPath[0:2] != ['@AH-64D Apache Longbow', 'Addons']:
            self.fileError(path, "Addons folder naming is invalid")
        
        if len(splitPath) <= 3:
            return
        
        if not reValidPboName.fullmatch(splitPath[2]):
            self.fileError(path, "PBO name is invalid")
        
        if any(map(lambda x: listPrefix(x,splitPath), self.ignorePaths)):
            return

        folderNames = splitPath[3:-1]
        for folderName in folderNames:
            if not reValidFolderName.fullmatch(folderName):
                self.fileError(path, f"Bad folder name: '{folderName}'")

        fileName = splitPath[-1]

        if fileName in self.ignoreFileNames:
            return

        if not (reValidFileName.fullmatch(fileName) or reValidConfigName.fullmatch(fileName)):
            self.fileError(path, f"Bad file name: '{fileName}'")    

def getFilesInRepo(repoDir):
    res = subprocess.run(["git", "ls-files"], text=True, stdout=subprocess.PIPE, cwd=repoDir)
    res.check_returncode()
    return res.stdout.splitlines()

def main():
    parser = argparse.ArgumentParser ( prog = "checkFilePaths"
        , description = "Checks that all files and folders in the repository follow naming conventions"
        )
    parser.add_argument('-c', '--config')
    parser.add_argument('-r', '--repo')
    parser.add_argument('files', nargs="*")
    args = parser.parse_args()
    
    if (args.repo is None):
        ret = subprocess.run(["git", "rev-parse", "--show-toplevel"], stdout=subprocess.PIPE, text=True)
        ret.check_returncode()
        args.repo = ret.stdout.splitlines()[0]
    
    if (args.config is None):
        args.config = os.path.join(args.repo, "tools", "checkConfig.yaml")

    with open(args.config, "r") as file:
        config = yaml.load(file, Loader=yaml.Loader)

    #if (args.files is None): 
    args.files = getFilesInRepo(args.repo)

    validator = FilePathValidator(**config)
    for filePath in args.files:
        validator.validateFilePath(filePath)

    if len(validator.errors) != 0:
        print(f"{len(validator.errors)} issues found:")
        for err in validator.errors:
            print(err)
        sys.exit(1)

    print("No issues found")

if __name__ == "__main__":
    main()