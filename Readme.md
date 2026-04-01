# AH-64D Official Project

[![](https://img.shields.io/steam/subscriptions/1351428303)](https://steamcommunity.com/sharedfiles/filedetails/?id=1351428303)
[![](https://img.shields.io/steam/favorites/1351428303)](https://steamcommunity.com/sharedfiles/filedetails/?id=1351428303)
[![](https://img.shields.io/discord/284725945921699840)](https://discord.gg/rB6yDDy)
[![](https://img.shields.io/github/v/release/AH-64D-Apache-Official-Project/AH-64D)](https://github.com/AH-64D-Apache-Official-Project/AH-64D/releases)

This mod, initially developed by Franze and Nodunit for Arma 2, aims to bring as realistic an aviation experience as practicably possible to this game.

The primary features of the aircraft are:

* Fully clickable cockpit with an emphasis on core mission systems.
* Realistic displays inspired by available documentation.
* Augmented flight model.
* Easy weapons & appearance customisation.

## History

This project is the official Arma 3 port of the legendary AH-64D Apache mod originally created by Franze & Nodunit for Arma 2. Launched in February 2017 with their blessing, this open-source initiative aims to deliver an unparalleled high-fidelity flight simulation experience within the Arma 3 engine. Built for sim-enthusiasts and real-life pilots, this repository represents the continued evolution of the "Official" branch following the transition from the original development team.

The 'Official' in the name is from when the original developers moved on, specifying that this branch-off of their work was the one that was the official port to Arma 3.

## Installation

### Via Steam Workshop (Recommended)

We recommend installing this mod through the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=1351428303). We do require [CBA](https://steamcommunity.com/workshop/filedetails/?id=450814997), but this mod should be automatically installed.

### Via Github Releases

To install via Github Releases, you must download a version from our [Releases Page](https://github.com/AH-64D-Apache-Official-Project/AH-64D/releases)

From there, once it is unzipped, you can add `@AH-64D Apache Longbow` as a local mod through the [Arma 3 launcher](https://community.bistudio.com/wiki/Arma_3:_Launcher_-_Mod_Handling).

Make sure you also have CBA, ACE & Hatchet Interaction Framework installed and active, as the launcher will not automatically handle this dependency when not installing through the workshop (It will remind you with an error if you forget).

### From Source (Development versions)

Use of these versions is at your own risk - these versions can be half-complete or intermediate versions that don't meet our standards for release. We recommend for anything other than development / testing to use the other two options.

## Development Guide

### SConstruct(SCONS) Build environment
The AH-64D is built with SConstcut, or for short, SCONS.

#### Prerequisite: python > 3
To install scons, you require python 3.
To check what python version you have installed, you can use the `python --version` command

#### Scons installation
Once you confirmed you have python installed, you can use the command
`python -m pip install scons`
To install scons

#### Pre-Commit
This is a tool that checks any new file names or paths that do not match our standard
`python -m pip install pre-commit`
To install Pre Commit

#### Troubleshooting
**PATH Warning**
Important: when installing scons, you might find the following error:
```
WARNING: The scripts scons-configure-cache.exe, scons.exe and sconsign.exe are installed in 'C:\Users\<user>\AppData\Local\Programs\Python\Python39\Scripts' which is not on PATH.
Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
```
If you find this, you will have to add the python folder to your PATH.
If you don't know how to add variables to your PATH, you can find more information here https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/

**Other errors**
If you find any other errors, please ask the dev team in the AH-64D Official Project discord server.

#### Usage
Once installed, you should be able to open the project's root folder in your terminal, and run `scons`.
This should generate fully built PBOs in your addons folder.

<a rel="license" href="https://www.bohemia.net/community/licenses/arma-public-license-share-alike" target="_blank" ><img src="https://data.bistudio.com/images/license/APL-SA.png" ><br>This work is licensed under the Arma Public License Share Alike </a>

## Support

Learning this aircraft can be difficult, and you will need resources to help you do it. We recommend you take a look at the following areas to learn more about the aircraft:

* Our [Discord server](https://discord.gg/rB6yDDy), in particular the `#faq` (Frequently Asked Questions) section.
* Our [wiki](https://github.com/AH-64D-Apache-Official-Project/AH-64D/wiki), which stores long-form information about the aircraft and its systems

### Bugs

Should you find any bugs, please come and talk to us on discord. We would love to discuss the problem with you and ensure that your issue is indeed an issue with the mod. If after this you know it is a bug then please submit an issue on our [issues page](https://github.com/AH-64D-Apache-Official-Project/AH-64D/issues) with as much information as possible.

## Contributing

If you enjoy our mod and wish to give back to the project then we would love to have you on the team! Please come and join us on our discord server and talk to us as that is where the majority of our organisation is done.

The main fields that we are looking for help in are as follows:

* **Programmers** - People who are experienced with the SQF programming language, who would like to work on the systems programming in the aircraft.
* **Artists** - We need people who can make textures and 3D models to work on the aircraft and additional content around it.
* **Documentation writers** - We are trying to expand our wiki, and other content to help us better teach our players about the features we add.
* **Testers** - We need people to test the new content we make, ensuring it all works as expected to the standards we expect.
