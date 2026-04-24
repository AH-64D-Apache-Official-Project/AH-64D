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

### Environment Setup

A setup script is provided that automatically installs and configures all required tools:

**Requirements:** Windows 10 1709+ and an administrator PowerShell session.

Run once after cloning the repository by double-clicking:

```
tools\Setup Development ENV.bat
```

The script installs the following tools, trying multiple methods for each before falling back to manual instructions:

| Tool | Purpose |
|---|---|
| Git | Version control |
| Python 3 | Runtime and pip package manager |
| SCons | Build system |
| pre-commit | Git hooks for code quality checks |
| PyYAML | Config file parsing |
| HEMTT | Mod builder and PBO packager |
Any tool that cannot be installed automatically will be listed at the end of the script output with a direct download URL.

After setup completes, open a new terminal so that PATH changes take effect, then verify with:

```powershell
git --version; python --version; scons --version; hemtt --version
```

### Building

From the project root, run:

```
scons
```

This runs `hemtt build` and places output in `.hemttout/build/`.
runs `hemtt build`
### SCons Targets

| Target | Description |
|---|---|
| `scons` | Build all PBOs via HEMTT (default) |
| `scons release` | Release build — signs PBOs, creates release archives, renames mod folder to `@fza_ah64_apache_longbow` |
| `scons docs` | Generate NaturalDocs documentation + MFD index reference (`docs/other/mfdindices.html`) |
| `scons symlinks` | Create NTFS junctions from the Arma 3 install into addon source folders (enables file patching) |
| `scons rmsymlinks` | Remove the above junctions |
| `scons -c` | Clean all build outputs (`.hemttout`, `releases`, `docs`, `buildTools`) |
| `scons -c release` | Clean release outputs only (`.hemttout`, `releases`) |


`scons` and `scons release` are equivalent to running `hemtt build` / `hemtt release` directly. SCons is used for the additional targets above (docs, symlinks, release repackaging).

### Build Pipeline

SCons is the top-level build orchestrator; PBO compilation is delegated to HEMTT.

#### `scons` / `scons release`

```
scons [release]
└─ hemtt build / hemtt release
    ├─ Pre-build hook: version_files.rhai writes version.hpp into each addon
    ├─ Preprocessing: resolves #include, #define, __EVAL() macros
    ├─ Linting: static analysis on SQF and configs
    ├─ Rapify: binarizes config.cpp → config.bin (skipped where [rapify] disabled)
    ├─ PBO packing → .hemttout/
    └─ (release only) Signing + zip archives in releases/
        ├─ Post-release hook: rename_zips.rhai renames fza_ah64-*.zip → ah64-*.zip
        └─ SCons repackages zips: inner folder @fza_ah64 → @fza_ah64_apache_longbowhe dev team in the AH-64D Official Project discord server.

### Version Management

The version is stored in `.hemtt/project.toml` under the `[version]` section (`major`, `minor`, `patch`, `build`).

#### Automatic local bumping

After `tools\Setup Development ENV.bat` is run, a git post-commit hook automatically updates the version on every commit and folds the change into that same commit — no separate "bump" commit is created.

The default behaviour is `build += 1`. You can trigger a semantic version bump by including a keyword anywhere in your commit message:

| Commit message contains | Effect |
|---|---|
| `[minor]` | `minor += 1`, `patch = 0`, `build = 0` |
| `[patch]` | `patch += 1`, `build = 0` |
| *(nothing)* | `build += 1` |

Example:
```
git commit -m "Refactor FCR sweep logic [patch]"
```

Manual edits to `minor` or `patch` in `project.toml` are also detected automatically: if the committed value is higher than the previous commit the hook resets downstream fields without needing a keyword.

`git commit --amend` is always skipped — the hook will never double-increment.

#### Merge conflict resolution

When two branches have diverged versions, a custom git merge driver resolves `.hemtt/project.toml` automatically:

| Field | Strategy |
|---|---|
| `minor` | Additive: `ours + (theirs − base)` — if increased, `patch` and `build` reset to 0 |
| `patch` | Additive: `ours + (theirs − base)` — if increased, `build` resets to 0 |
| `build` | Additive: `ours + (theirs − base)` — only if no version boundary was crossed |

The merge driver is registered in your local `.git/config` by the setup script and requires no manual intervention.

#### CI fallback

A GitHub Actions workflow (`.github/workflows/bump_build.yml`) increments `build` whenever a PR merges to `master`. This catches any build number that wasn't bumped locally and commits with `[skip ci]` to avoid triggering further runs.

---

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

## Usage

<a rel="license" href="https://www.bohemia.net/community/licenses/arma-public-license-nd" target="_blank" ><img src="https://data.bistudio.com/images/license/APL-ND.png" ><br>This work is licensed under the Arma Public License No Derivatives (APL-ND) </a>
