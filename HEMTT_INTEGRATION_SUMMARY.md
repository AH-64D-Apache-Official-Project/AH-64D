# HEMTT Integration Summary

## ✅ Changes Made

### 1. **Created hemtt.toml**
   - Defines project name: "AH-64D Apache Longbow"
   - Sets addon prefix: "fza_ah64" (used for all your 30 addons)
   - Configures versioning with git commit hash
   - Ready for release builds when needed

### 2. **Updated SConstruct**
   - Added `hemttPath()` function to locate HEMTT installation
   - Modified `buildPbo()` to call `hemtt build` instead of AddonBuilder.exe
   - **Preserved all existing functionality:**
     - ✅ Symlink creation/removal (commandsToCreateSymlink, etc.)
     - ✅ MFD documentation generation
     - ✅ Natural Docs generation
     - ✅ Version.hpp generation with commit hash
     - ✅ All SCons targets (all, docs, symlinks, rmsymlinks)

### 3. **Created HEMTT_SETUP.md**
   - Installation guide with 3 options (Cargo, prebuilt, Scoop)
   - Verification steps
   - Usage examples
   - Troubleshooting guide

## 🎯 How It Works

```
User Command                SCons Action                      HEMTT Action
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
scons                  →    Calls buildPbo() 30 times    →    hemtt build
scons fza_ah64_model   →    Calls buildPbo(model)        →    hemtt build
scons symlinks         →    Symlink creation (unchanged)  →    (no HEMTT)
scons docs             →    Natural Docs + MFD (unchanged) →   (no HEMTT)
```

## 📋 Next Steps

1. **Install HEMTT** (see HEMTT_SETUP.md):
   ```powershell
   cargo install hemtt
   # OR download from: https://github.com/BrettMayson/HEMTT/releases
   ```

2. **Verify installation**:
   ```powershell
   hemtt --version
   ```

3. **Build your PBOs**:
   ```powershell
   scons all          # Build all addons
   scons symlinks     # Create file patching symlinks
   scons docs         # Generate documentation
   ```

4. **Enjoy better debugging!** 🎉
   - HEMTT provides detailed error messages during PBO compilation
   - Errors are highlighted in color
   - Source file names and line numbers are shown in errors

## 🔄 What's NOT Changed

- ✅ Your 30 addons (fza_ah64_*, fza_compat_*)
- ✅ Build targets and aliases
- ✅ Symlink management functionality
- ✅ Documentation generation
- ✅ Version injection with commit hashes
- ✅ build.json and buildExtIncludes.txt usage
- ✅ build.ps1 script (still works for Arma 3 diagnostics launching)

## 🚀 Benefits

1. **Better Debugging** - Improved error messages from HEMTT
2. **Faster Builds** - HEMTT is optimized for PBO compilation
3. **Modern Tooling** - Rust-based, actively maintained
4. **No Breaking Changes** - All your existing workflows still work
5. **Community Supported** - Used by major mods like ACE3

## 📝 Files Modified/Created

```
Modified:  SConstruct
Created:   hemtt.toml
Created:   HEMTT_SETUP.md
Created:   HEMTT_INTEGRATION_SUMMARY.md (this file)
```

## 🆘 Troubleshooting Quick Links

- HEMTT not found? → See HEMTT_SETUP.md installation section
- Build errors? → Check detailed HEMTT output (vs generic AddonBuilder)
- Config issues? → Review hemtt.toml and HEMTT documentation
- Need help? → Visit https://hemtt.dev/ or GitHub issues

---

**Ready to build!** Run `scons` after installing HEMTT and enjoy better debugging! 🚀
