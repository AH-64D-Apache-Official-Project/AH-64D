# HEMTT Installation & Setup Guide

## What Changed

Your build system has been updated to use **HEMTT** for PBO compilation instead of Arma 3 Tools AddonBuilder. This provides:
- ✅ Better debugging output during builds
- ✅ Faster, more reliable PBO compilation
- ✅ All existing functionality preserved (symlinks, docs, etc.)

## Installation Steps

### Option 1: Install via Cargo (Recommended)
If you have Rust installed:
```powershell
cargo install hemtt
```

### Option 2: Download Prebuilt Binary
1. Visit: https://github.com/BrettMayson/HEMTT/releases
2. Download the latest Windows release (`.exe` or `.zip`)
3. Extract to a location in your PATH, or note the path for configuration

### Option 3: Install via Scoop (if available)
```powershell
scoop install hemtt
```

## Verification

After installation, verify HEMTT is accessible:
```powershell
hemtt --version
```

Should output something like: `HEMTT vX.X.X`

## How It Works

1. **hemtt.toml** - New configuration file that defines:
   - Project name: "AH-64D Apache Longbow"
   - Addon prefix: "fza_ah64"
   - Versioning info

2. **SCons integration** - `SConstruct` now calls `hemtt build` instead of AddonBuilder
   - All your existing targets still work: `scons all`, `scons symlinks`, `scons docs`
   - The buildPbo() function now uses HEMTT internally
   - All other functionality (symlinks, docs, etc.) is unchanged

3. **Build commands** - Use HEMTT the same way you did before:
```powershell
# Build all addons
scons

# Build specific addon
scons fza_ah64_model

# Create symlinks for file patching
scons symlinks

# Generate documentation
scons docs
```

## Troubleshooting

### "HEMTT not found" error
- Ensure HEMTT is installed and in your PATH
- Check `hemtt --version` works in PowerShell
- Update `PATH` environment variable if needed

### Build failures
- HEMTT requires the `hemtt.toml` file in the project root
- Check that all $PBOPREFIX$ files exist in addon folders
- Review HEMTT output for detailed error messages (this is the main benefit!)

### Addon not compiling
- Verify the addon folder contains a `$PBOPREFIX$` file
- Check that addon files are valid SQF/config syntax
- HEMTT provides better error messages than AddonBuilder

## Next Steps

1. Install HEMTT using one of the methods above
2. Run `scons` to build all addons
3. Verify PBOs are generated correctly in `@AH-64D Apache Longbow\Addons\*\*.pbo`
4. Test symlink creation: `scons symlinks`
5. Run Arma 3 diagnostics to test in-game

## Resources

- HEMTT Documentation: https://hemtt.dev/
- HEMTT GitHub: https://github.com/BrettMayson/HEMTT
- Configuration Reference: https://hemtt.dev/configuration.html

## Still Using AddonBuilder?

If you need to revert to AddonBuilder for any reason, the old code is still available in git history. However, we recommend sticking with HEMTT for the better debugging experience!
