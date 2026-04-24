# AH-64D Official Project

<p align="center">
  <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1351428303"><img src="https://img.shields.io/steam/subscriptions/1351428303?style=for-the-badge&logo=steam&label=Subscribers&color=1b2838" alt="Steam Subscriptions"></a>
  <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1351428303"><img src="https://img.shields.io/steam/favorites/1351428303?style=for-the-badge&logo=steam&label=Favourites&color=1b2838" alt="Steam Favourites"></a>
  <a href="https://discord.gg/rB6yDDy"><img src="https://img.shields.io/discord/284725945921699840?style=for-the-badge&logo=discord&label=Discord&color=5865F2" alt="Discord"></a>
  <a href="https://github.com/AH-64D-Apache-Official-Project/AH-64D/releases"><img src="https://img.shields.io/github/v/release/AH-64D-Apache-Official-Project/AH-64D?style=for-the-badge&logo=github&label=Latest+Release&color=238636" alt="Latest Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-APL--ND-red?style=for-the-badge" alt="License"></a>
</p>

<p align="center"><em>Originally developed by Franze & Nodunit for Arma 2 — brought to Arma 3 with their blessing in February 2017.</em></p>

---

**Key features:**

- 🖱️ Fully clickable cockpit with an emphasis on core mission systems
- 📺 Realistic displays inspired by available documentation
- ✈️ Augmented flight model
- 🔧 Easy weapons & appearance customisation

---

## 📋 Table of Contents

- [History](#-history)
- <details><summary><a href="#-installation">Installation</a></summary>

  - [Via Steam Workshop](#via-steam-workshop-recommended)
  - [Via GitHub Releases](#via-github-releases)
  - [From Source](#from-source-development-only)

  </details>
- <details><summary><a href="#development-guide">Development Guide</a></summary>

  - [Quick Start](#-quick-start)
  - [Environment Setup](#environment-setup)
  - [Building](#building)
  - [Version Management](#version-management)

  </details>
- <details><summary><a href="#-player-support">Player Support</a></summary>

  - [Bugs](#-bugs)

  </details>
- [Contributing](#-contributing)
- [License](#-license)

---

## 📖 History

This project is the official Arma 3 port of the legendary AH-64D Apache mod originally created by Franze & Nodunit for Arma 2. Launched in February 2017 with their blessing, this open-source initiative aims to deliver an unparalleled high-fidelity flight simulation experience within the Arma 3 engine.

The *'Official'* in the name originates from when the original developers moved on, specifying that this branch was the official Arma 3 port of their work.

---

## 📦 Installation

### Via Steam Workshop *(Recommended)*

[![Steam Workshop](https://img.shields.io/badge/Steam_Workshop-Install_Now-1b2838?style=for-the-badge&logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=1351428303)

Install through the Steam Workshop. Required dependencies will be listed by Arma on launch — the launcher will prompt you to install any that are missing.

### Via GitHub Releases

[![GitHub Releases](https://img.shields.io/badge/GitHub-Download_Release-238636?style=for-the-badge&logo=github)](https://github.com/AH-64D-Apache-Official-Project/AH-64D/releases)

Download a release, unzip it, then add `@AH-64D Apache Longbow` as a local mod in the [Arma 3 launcher](https://community.bistudio.com/wiki/Arma_3:_Launcher_-_Mod_Handling).

> [!IMPORTANT]
> CBA, ACE, and Hatchet Interaction Framework must be installed and active. The launcher will not handle these dependencies automatically when installing outside the Workshop.

### From Source *(Development only)*

> [!WARNING]
> Source builds may be incomplete or unstable. Use Steam Workshop or GitHub Releases for normal play.

See the [Development Guide](#development-guide) below.

---

<details>
<summary><h2 id="development-guide">🛠 Development Guide</h2></summary>

### ⚡ Quick Start

1. Clone the repository
2. Run the setup script (admin PowerShell, Windows 10 1709+):
   ```
   tools\Setup Development ENV.bat
   ```
3. Open a new terminal, then build:
   ```
   scons
   ```

> [!TIP]
> Run the setup script once after cloning and it handles everything else automatically.

---

<details>
<summary><h3 id="environment-setup">🔧 Environment Setup</h3></summary>

The setup script automatically installs and configures all required tools:

| Tool | Purpose |
|---|---|
| Git | Version control |
| Python 3 | Runtime and pip package manager |
| SCons | Build system |
| pre-commit | Git hooks for code quality checks |
| PyYAML | Config file parsing |
| HEMTT | Mod builder and PBO packager |

Any tool that cannot be installed automatically will be listed at the end of the script output with a direct download URL.

After setup, verify everything is on PATH:
```powershell
git --version; python --version; scons --version; hemtt --version
```

</details>

---

<details>
<summary><h3 id="building">🔨 Building</h3></summary>

| Command | Description |
|---|---|
| `scons` | Build all PBOs via HEMTT (default) |
| `scons release` | Release build — signs PBOs, creates archives, renames mod folder |
| `scons docs` | Generate NaturalDocs documentation + MFD index reference |
| `scons symlinks` | Create NTFS junctions into addon source folders (enables file patching) |
| `scons rmsymlinks` | Remove the above junctions |
| `scons -c` | Clean all build outputs |
| `scons -c release` | Clean release outputs only |

`scons` and `scons release` are equivalent to running `hemtt build` / `hemtt release` directly. SCons is used for the additional targets above.

<details>
<summary>🔍 Build pipeline internals</summary>

SCons is the top-level build orchestrator; PBO compilation is delegated to HEMTT.

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
        └─ SCons repackages zips: inner folder @fza_ah64 → @fza_ah64_apache_longbow
```

</details>

</details>

---

<details>
<summary><h3 id="version-management">🏷️ Version Management</h3></summary>

The version is stored in `.hemtt/project.toml` under the `[version]` section (`major`, `minor`, `patch`, `build`).

**Automatic local bumping**

After setup, a git post-commit hook automatically updates the version on every commit and folds the change into that same commit — no separate "bump" commit is created.

The default behaviour is `build += 1`. Include a keyword in your commit message to trigger a semantic bump:

| Commit message contains | Effect |
|---|---|
| `[minor]` | `minor += 1`, `patch = 0`, `build = 0` |
| `[patch]` | `patch += 1`, `build = 0` |
| *(nothing)* | `build += 1` |

```
git commit -m "Refactor FCR sweep logic [patch]"
```

Manual edits to `minor` or `patch` in `project.toml` are also detected automatically — if the committed value is higher than the previous commit the hook resets downstream fields without needing a keyword.

`git commit --amend` is always skipped — the hook will never double-increment.

<details>
<summary>🔀 Merge conflict resolution</summary>

When two branches have diverged versions, a custom git merge driver resolves `.hemtt/project.toml` automatically:

| Field | Strategy |
|---|---|
| `minor` | Additive: `ours + (theirs − base)` — if increased, `patch` and `build` reset to 0 |
| `patch` | Additive: `ours + (theirs − base)` — if increased, `build` resets to 0 |
| `build` | Additive: `ours + (theirs − base)` — only if no version boundary was crossed |

The merge driver is registered in your local `.git/config` by the setup script and requires no manual intervention.

A GitHub Actions workflow (`.github/workflows/bump_build.yml`) also increments `build` whenever a PR merges to `master` as a CI fallback — committing with `[skip ci]` to avoid re-triggering.

</details>

</details>

</details>

---

## 🆘 Player Support

Learning this aircraft can be difficult. The following resources will help:

[![Discord](https://img.shields.io/badge/Discord-Join_Server-5865F2?style=for-the-badge&logo=discord)](https://discord.gg/rB6yDDy)
[![Wiki](https://img.shields.io/badge/GitHub_Wiki-Read_Guides-238636?style=for-the-badge&logo=github)](https://github.com/AH-64D-Apache-Official-Project/AH-64D/wiki)

- **Discord** — check the `#faq` channel first for common questions
- **Wiki** — long-form guides on aircraft systems and procedures

### 🐛 Bugs

> [!CAUTION]
> Please confirm the issue on Discord before filing a report — many common issues are config or dependency problems, not bugs.

Once confirmed, submit a report on the [Issues page](https://github.com/AH-64D-Apache-Official-Project/AH-64D/issues) with as much detail as possible.

---

## 🤝 Contributing

We'd love to have you on the team!

[![Discord](https://img.shields.io/badge/Discord-Talk_to_Us-5865F2?style=for-the-badge&logo=discord)](https://discord.gg/rB6yDDy)

We're particularly looking for:

| Role | Description |
|---|---|
| 💻 **Programmers** | SQF experience, working on aircraft systems |
| 🎨 **Artists** | Textures and 3D models |
| 📝 **Documentation writers** | Expanding the wiki and in-mod help |
| 🧪 **Testers** | Verifying new features meet our quality bar |

---

## ⚖️ License

<a rel="license" href="https://www.bohemia.net/community/licenses/arma-public-license-nd" target="_blank"><img src="https://data.bistudio.com/images/license/APL-ND.png"><br>This work is licensed under the Arma Public License No Derivatives (APL-ND)</a>
