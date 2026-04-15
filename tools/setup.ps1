#Requires -RunAsAdministrator
<#
.SYNOPSIS
    First-time setup script for AH-64D mod development.

.DESCRIPTION
    Installs and configures all tools required to build, test, and release
    the AH-64D Apache Longbow mod:
      - Git          (version control,  via winget / Chocolatey / GitHub release)
      - Python 3     (runtime + pip,     via winget / Chocolatey / python.org)
      - SCons        (build system,     via pip / Chocolatey)
      - pre-commit   (git hooks,        via pip / Chocolatey)
      - PyYAML       (config lib,       via pip)
      - HEMTT        (mod builder,      via winget / GitHub release)
      - Arma 3 Tools (config binarizer, via Steam App ID 233800)

    Each tool tries multiple install methods before giving up.
    Any tool that cannot be installed automatically is listed at the
    end with a direct download URL for manual installation.

    Run once after cloning the repository:
        powershell -ExecutionPolicy Bypass -File tools\setup.ps1

.NOTES
    Requires Windows 10 1709+ (for winget).
    Administrator rights are required to install system tools.
#>
param(
    [switch]$SkipUpdateCheck
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# When launched elevated via UAC (e.g. double-clicking setup.bat), the working
# directory resets. Navigate to the repo root (parent of the tools\ folder).
Set-Location (Split-Path $PSScriptRoot -Parent)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
function Write-Step([string]$msg) {
    Write-Host "`n==> $msg" -ForegroundColor Cyan
}

function Write-OK([string]$msg) {
    Write-Host "    [OK]   $msg" -ForegroundColor Green
}

function Write-Warn([string]$msg) {
    Write-Host "    [WARN] $msg" -ForegroundColor Yellow
}

function Write-Fail([string]$msg) {
    Write-Host "    [FAIL] $msg" -ForegroundColor Red
}

function Test-Command([string]$name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# Checks that python is a real install (not the Windows Store stub).
# The Store stub exists as a Get-Command hit but outputs nothing / exits 9009.
function Test-Python {
    if (-not (Test-Command "python")) { return $false }
    $ver = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
    return ($ver -match '^Python 3\.\d+\.\d+')
}

function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

function Broadcast-EnvChange {
    # Broadcast WM_SETTINGCHANGE from this elevated process. Handles the case
    # where the type is already registered from a previous call in this session.
    try {
        if (-not ([System.Management.Automation.PSTypeName]'Win32.WinEnv').Type) {
            Add-Type -Namespace 'Win32' -Name 'WinEnv' -MemberDefinition '
                [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
                public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg,
                    UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
            ' -ErrorAction SilentlyContinue
        }
        $result = [UIntPtr]::Zero
        [Win32.WinEnv]::SendMessageTimeout([IntPtr]0xffff, 0x001A, [UIntPtr]::Zero, 'Environment', 2, 5000, [ref]$result) | Out-Null
    } catch { }

    # Also send from a non-elevated (medium-integrity) process via Shell.Application.
    # Explorer runs at medium integrity and may not receive the message from this
    # elevated process. The Shell.Application COM server runs in Explorer's context,
    # so the spawned helper inherits medium integrity and Explorer will accept it.
    try {
        $tmp = [IO.Path]::GetTempFileName() + ".ps1"
        @'
try {
    Add-Type -Namespace Win32 -Name WinEnvHelper -MemberDefinition '[DllImport("user32.dll")]public static extern IntPtr SendMessageTimeout(IntPtr h,uint m,UIntPtr w,string l,uint f,uint t,out UIntPtr r);' -ErrorAction SilentlyContinue
    $r = [UIntPtr]::Zero
    [Win32.WinEnvHelper]::SendMessageTimeout([IntPtr]0xffff, 0x1A, [UIntPtr]::Zero, 'Environment', 2, 5000, [ref]$r)
} catch {}
'@ | Set-Content -Path $tmp -Encoding UTF8
        $shell = New-Object -ComObject Shell.Application
        $shell.ShellExecute('powershell.exe', "-NonInteractive -WindowStyle Hidden -File `"$tmp`"", '', 'open', 0)
    } catch { }
}

function Try-Winget([string[]]$wingetArgs) {
    if (-not (Test-Command "winget")) {
        Write-Warn "winget not available on this system."
        return $false
    }
    try {
        $ErrorActionPreference = "Continue"
        # Run winget directly (no pipe) so it gets a real TTY and renders its
        # own progress bar instead of printing spinner frames line-by-line.
        & winget @wingetArgs
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

# Tracks tools that could not be installed - shown at end with manual URLs.
$script:manualInstalls = [System.Collections.Generic.List[string]]::new()

# Snapshot the PATH this process inherited (from Explorer's cached environment).
# Compared against the registry at the end of the PATH audit to detect a stale
# Explorer cache — the common cause of scons/hemtt not being found in VS Code
# terminals even after setup has correctly written the registry.
$script:inheritedPath = $env:PATH

# Set to $true when Steam was opened to install Arma 3 Tools, so we can
# prompt the user to re-run the script once the Steam install completes.
$script:arma3ToolsInstalling = $false

# Set to $true if the user opts in to checking for updates on an already-configured machine.
$script:checkUpdates = $false

# Set to $true if a tool was installed but requires a new terminal session to appear on PATH.
$script:needsRestart = $false

# ---------------------------------------------------------------------------
# Verify we are inside the repo root
# ---------------------------------------------------------------------------
if (-not (Test-Path "SConstruct")) {
    Write-Error "Run this script from the repository root (the folder containing SConstruct)."
    exit 1
}

# ---------------------------------------------------------------------------
# Quick pre-scan - if everything is already present, offer an update check
# ---------------------------------------------------------------------------
$allPresent = (Test-Command "git") -and (Test-Python) -and
              (Test-Command "scons") -and (Test-Command "hemtt") -and
              (Test-Command "pre-commit")

if ($allPresent -and -not $SkipUpdateCheck) {
    Write-Host ""
    Write-Host "  All tools are already installed." -ForegroundColor Green
    $updateResponse = Read-Host "  Check for updates? [Y/n]"
    if ($updateResponse -eq '' -or $updateResponse -match '^[Yy]') {
        $script:checkUpdates = $true
        Write-Host "  Update check enabled." -ForegroundColor Cyan
    } else {
        Write-Host "  Skipping update check." -ForegroundColor DarkGray
    }
}

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------
Write-Step "Checking Git..."

if (Test-Command "git") {
    if ($script:checkUpdates) {
        Write-Host "    Checking for Git update..." -ForegroundColor DarkGray
        Try-Winget @("upgrade", "--id", "Git.Git", "--silent",
            "--accept-package-agreements", "--accept-source-agreements") | Out-Null
        Refresh-Path
    }
    $gitver = & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1
    Write-OK "Found: $gitver"
} else {
    # Method 1: winget
    Write-Host "    Trying winget (this may take a moment)..." -ForegroundColor DarkGray
    Try-Winget @("install", "--id", "Git.Git", "--source", "winget", "--scope", "user",
        "--accept-package-agreements", "--accept-source-agreements") | Out-Null
    Refresh-Path

    if (Test-Command "git") {
        $gitver = & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1
        Write-OK "Git installed via winget: $gitver"
    } else {
        # Method 2: Chocolatey
        Write-Warn "winget failed. Trying Chocolatey..."
        if (Test-Command "choco") {
            try {
                $ErrorActionPreference = "Continue"
                Write-Host "    Running: choco install git (this may take a moment)..." -ForegroundColor DarkGray
                & choco install git --yes 2>&1 | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                Refresh-Path
            } catch {
                Write-Warn "Chocolatey threw an error: $_"
            }
        } else {
            Write-Host "    Chocolatey not found, skipping." -ForegroundColor DarkGray
        }

        if (Test-Command "git") {
            $gitver = & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1
            Write-OK "Git installed via Chocolatey: $gitver"
        } else {
            # Method 3: Direct download from GitHub (git-for-windows)
            Write-Warn "Chocolatey failed. Trying direct download from GitHub..."
            try {
                $ErrorActionPreference = "Continue"
                $release = Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest" -UseBasicParsing
                $asset   = $release.assets | Where-Object { $_.name -like "Git-*-64-bit.exe" } | Select-Object -First 1
                if (-not $asset) { throw "No 64-bit installer found in latest GitHub release." }

                $installerPath = Join-Path $env:TEMP "git_installer.exe"
                Write-Host "    Downloading $($asset.name)..." -ForegroundColor DarkGray
                Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installerPath -UseBasicParsing
                Write-Host "    Download complete. Running installer (this may take a moment)..." -ForegroundColor DarkGray
                # Git for Windows uses Inno Setup - /VERYSILENT suppresses all UI
                $proc = Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT", "/NORESTART", "/NOCANCEL", "/SP-" -PassThru -Wait
                if ($proc.ExitCode -ne 0) { throw "Installer exited with code $($proc.ExitCode)." }
                Write-Host "    Installer finished." -ForegroundColor DarkGray
                Remove-Item $installerPath -ErrorAction SilentlyContinue
                Refresh-Path
            } catch {
                Write-Warn "Direct download failed: $_"
            }

            if (Test-Command "git") {
                $gitver = & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1
                Write-OK "Git installed from GitHub: $gitver"
            } else {
                Write-Fail "Git could not be installed automatically."
                $script:manualInstalls.Add("Git        ->  https://git-scm.com/download/win")
            }
        }
    }
}

# ---------------------------------------------------------------------------
# Python 3
# ---------------------------------------------------------------------------
Write-Step "Checking Python 3..."

if (Test-Python) {
    $pyver = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
    Write-OK "Found: $pyver"
} else {
    # Method 1: winget
    Write-Host "    Trying winget (this may take a moment)..." -ForegroundColor DarkGray
    # Find the latest stable Python minor version:
    # 1. Query endoflife.date for non-EOL stable releases (authoritative, excludes pre-releases)
    # 2. Cross-check against what winget actually has available (prevents picking a version
    #    that endoflife knows about but winget hasn't published a package for yet)
    # 3. Fall back to 3.13 if either source is unreachable.
    $pythonWingetId = try {
        $releases = Invoke-RestMethod "https://endoflife.date/api/python.json" -ErrorAction Stop
        # Get all non-EOL stable minor versions, highest first
        $stableMinors = $releases |
            Where-Object { $_.latest -match '^3\.\d+\.\d+$' -and ($_.eol -eq $false -or ([datetime]$_.eol) -gt (Get-Date)) } |
            ForEach-Object { ([version]$_.latest).Minor } |
            Sort-Object -Descending

        # Get the winget packages that actually exist right now
        $wingetAvailable = winget search --id Python.Python.3 --source winget 2>$null |
            Select-String 'Python\.Python\.3\.(\d+)' |
            ForEach-Object { if ($_ -match 'Python\.Python\.3\.(\d+)') { [int]$matches[1] } }

        # Pick the highest stable minor that winget actually has
        $best = $stableMinors | Where-Object { $wingetAvailable -contains $_ } | Select-Object -First 1
        if ($best) { "Python.Python.3.$best" } else { "Python.Python.3.13" }
    } catch { "Python.Python.3.13" }
    Write-Host "    Using winget package: $pythonWingetId" -ForegroundColor DarkGray
    Try-Winget @("install", "--id", $pythonWingetId, "--source", "winget", "--force",
        "--accept-package-agreements", "--accept-source-agreements") | Out-Null
    Refresh-Path
    # winget may report "No available upgrade found" (already installed) with a non-zero
    # exit, but Python is still present. Re-check PATH from registry in case it was
    # just installed and the MSI PATH write hasn't propagated to $env:PATH yet.
    if (-not (Test-Python)) {
        $pyExe = Get-ChildItem "$env:LOCALAPPDATA\Programs\Python" -Filter "python.exe" -Recurse -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($pyExe) { $env:PATH += ";$($pyExe.DirectoryName)" }
    }

    if (Test-Python) {
        $pyver = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
        Write-OK "Python installed via winget: $pyver"
    } else {
        # Method 2: Chocolatey
        Write-Warn "winget failed. Trying Chocolatey..."
        if (Test-Command "choco") {
            try {
                $ErrorActionPreference = "Continue"
                Write-Host "    Running: choco install python313 (this may take a moment)..." -ForegroundColor DarkGray
                # Use python313 (stable) rather than python which may resolve to a pre-release.
                & choco install python313 --yes 2>&1 | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                Refresh-Path
            } catch {
                Write-Warn "Chocolatey threw an error: $_"
            }
        } else {
            Write-Host "    Chocolatey not found, skipping." -ForegroundColor DarkGray
        }

        if (Test-Python) {
            $pyver = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
            Write-OK "Python installed via Chocolatey: $pyver"
        } else {
            # Method 3: Direct download from python.org
            Write-Warn "Chocolatey failed. Trying direct download from python.org..."
            try {
                $ErrorActionPreference = "Continue"
                $dlPage = Invoke-WebRequest -Uri "https://www.python.org/downloads/windows/" -UseBasicParsing
                $match  = [regex]::Match($dlPage.Content,
                    'href="(https://www\.python\.org/ftp/python/(3\.\d+\.\d+)/python-\2-amd64\.exe)"')
                if (-not $match.Success) { throw "Could not find installer link on python.org." }

                $installerUrl  = $match.Groups[1].Value
                $installerPath = Join-Path $env:TEMP "python_installer.exe"
                Write-Host "    Downloading Python $($match.Groups[2].Value) installer..." -ForegroundColor DarkGray
                Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
                Write-Host "    Download complete. Running installer (this may take a moment)..." -ForegroundColor DarkGray
                $proc = Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1" -PassThru -Wait
                if ($proc.ExitCode -ne 0) { throw "Installer exited with code $($proc.ExitCode)." }
                Write-Host "    Installer finished." -ForegroundColor DarkGray
                Remove-Item $installerPath -ErrorAction SilentlyContinue
                Refresh-Path
            } catch {
                Write-Warn "Direct download failed: $_"
            }

            if (Test-Python) {
                $pyver = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
                Write-OK "Python installed from python.org: $pyver"
            } else {
                Write-Fail "Python could not be installed automatically."
                Write-Host ""
                Write-Host "    Please install Python 3 manually:" -ForegroundColor Yellow
                Write-Host "    https://www.python.org/downloads/windows/" -ForegroundColor Cyan
                Write-Host "    Make sure to check 'Add Python to PATH' during installation." -ForegroundColor Yellow
                Write-Host ""
                $script:manualInstalls.Add("Python 3   ->  https://www.python.org/downloads/windows/")
            }
        }
    }
}

# ---------------------------------------------------------------------------
# pip packages: SCons, pre-commit, PyYAML
# ---------------------------------------------------------------------------
if (Test-Python) {
    Write-Step "Checking pip packages (scons, pre-commit, pyyaml)..."
    try {
        $ErrorActionPreference = "Continue"
        $missing = [System.Collections.Generic.List[string]]::new()
        if (-not (Test-Command "scons"))     { $missing.Add("scons") }
        if (-not (Test-Command "pre-commit")) { $missing.Add("pre-commit") }
        # pyyaml has no CLI command - do a quick import check instead
        $yamlCheck = & { $ErrorActionPreference = "Continue"; python -c "import yaml; print('ok')" 2>&1 } | Select-Object -First 1
        if ($yamlCheck -ne 'ok') { $missing.Add("pyyaml") }

        if ($missing.Count -eq 0 -and -not $script:checkUpdates) {
            Write-OK "pip packages already installed."
        } elseif ($missing.Count -eq 0 -and $script:checkUpdates) {
            Write-Host "    Checking for pip package updates..." -ForegroundColor DarkGray
            python -m pip install --upgrade pip --quiet
            python -m pip install --upgrade scons pre-commit pyyaml --quiet
            Write-OK "pip packages up to date."
        } else {
            Write-Host "    Installing missing packages: $($missing -join ', ')..." -ForegroundColor DarkGray
            python -m ensurepip 2>&1 | Out-Null
            # Upgrade pip first — outdated pip is a common cause of install failures.
            python -m pip install --upgrade pip --quiet 2>&1 | Out-Null
            # Install without --user: Python's own installer already puts its Scripts dir
            # on the User PATH, so scons/pre-commit will be found in any new terminal.
            # --user would put them in AppData\Roaming\...\Scripts which is NOT on User PATH.
            python -m pip install $missing --quiet 2>&1 | Out-Null
            Write-OK "pip packages installed."
        }
    } catch {
        Write-Warn "pip install failed, retrying without --quiet..."
        try {
            $ErrorActionPreference = "Continue"
            python -m pip install --upgrade pip 2>&1 | Out-Null
            python -m pip install --upgrade scons pre-commit pyyaml
            Write-OK "pip packages installed (retry succeeded)."
        } catch {
            # Fallback: Chocolatey for scons and pre-commit (pyyaml has no choco package)
            Write-Warn "pip failed. Trying Chocolatey for scons and pre-commit..."
            $pipFailed = $true
            if (Test-Command "choco") {
                try {
                    $ErrorActionPreference = "Continue"
                    if (-not (Test-Command "scons")) {
                        Write-Host "    choco install scons..." -ForegroundColor DarkGray
                        & choco install scons --yes 2>&1 | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                    }
                    if (-not (Test-Command "pre-commit")) {
                        Write-Host "    choco install pre-commit..." -ForegroundColor DarkGray
                        & choco install pre-commit --yes 2>&1 | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                    }
                    Refresh-Path
                    $pipFailed = $false
                } catch {
                    Write-Warn "Chocolatey threw an error: $_"
                }
            } else {
                Write-Host "    Chocolatey not found, skipping." -ForegroundColor DarkGray
            }
            if ($pipFailed) {
                Write-Fail "pip packages could not be installed: $_"
                $script:manualInstalls.Add("SCons      ->  pip install scons        (https://pypi.org/project/SCons/)")
                $script:manualInstalls.Add("pre-commit ->  pip install pre-commit   (https://pre-commit.com/#install)")
            }
        }
    }

    # Ensure the Python Scripts directory is in User PATH (HKCU) so that scons
    # and pre-commit work in non-elevated terminals after setup completes.
    # Writing to User PATH is correct: winget installs Python per-user, so the
    # Scripts dir belongs in the user's own PATH. UAC elevation does not change
    # the user account, so SetEnvironmentVariable(..., "User") writes to the
    # right registry hive. This runs unconditionally — not just as a fallback —
    # because relying on the Python installer to have already written this entry
    # is what caused scons to only work from the elevated session.
    try {
        $ErrorActionPreference = "Continue"
        $scriptsDir = & python -c "import sysconfig; print(sysconfig.get_path('scripts'))" 2>$null
        if ($scriptsDir -and (Test-Path $scriptsDir)) {
            $userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
            if ($userPath -notlike "*$scriptsDir*") {
                [System.Environment]::SetEnvironmentVariable("PATH", "$userPath;$scriptsDir", "User")
                Write-Host "    Added Python Scripts to User PATH: $scriptsDir" -ForegroundColor DarkGray
                # Tell Explorer (and any process listening) that PATH changed so
                # terminals opened after this point will inherit the new value.
                Broadcast-EnvChange
            }
            if ($env:PATH -notlike "*$scriptsDir*") { $env:PATH += ";$scriptsDir" }
        }
    } catch { }

    Refresh-Path

    if (-not (Test-Command "scons")) {
        Write-Warn "'scons' not on PATH. A new terminal session is needed."
        $script:needsRestart = $true
    } else {
        $sconsver = & { $ErrorActionPreference = "Continue"; scons --version 2>&1 } | Select-Object -First 1
        Write-OK "SCons: $sconsver"
    }
} else {
    Write-Warn "Skipping pip packages - Python is not available."
}

# ---------------------------------------------------------------------------
# HEMTT
# ---------------------------------------------------------------------------
Write-Step "Checking HEMTT..."

if (Test-Command "hemtt") {
    if ($script:checkUpdates) {
        Write-Host "    Checking for HEMTT update..." -ForegroundColor DarkGray
        Try-Winget @("upgrade", "--id", "BrettMayson.HEMTT", "--silent",
            "--accept-package-agreements", "--accept-source-agreements") | Out-Null
        Refresh-Path
    }
    $hemttver = & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1
    Write-OK "Found: $hemttver"
} else {
    # Method 1: winget
    Write-Host "    Trying winget..." -ForegroundColor DarkGray
    Try-Winget @("install", "--id", "BrettMayson.HEMTT", "--source", "winget", "--scope", "user",
        "--silent", "--accept-package-agreements", "--accept-source-agreements") | Out-Null
    Refresh-Path

    if (Test-Command "hemtt") {
        $hemttver = & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1
        Write-OK "HEMTT installed via winget: $hemttver"
    } else {
        # Method 2: GitHub release zip download
        Write-Warn "winget failed. Trying GitHub release download..."
        try {
            $ErrorActionPreference = "Continue"
            $release = Invoke-RestMethod -Uri "https://api.github.com/repos/BrettMayson/HEMTT/releases/latest" -UseBasicParsing
            $asset   = $release.assets | Where-Object {
                $_.name -like "*windows*x86_64*.zip" -or $_.name -like "*win64*.zip"
            } | Select-Object -First 1

            if (-not $asset) { throw "No Windows asset found in latest GitHub release." }

            $zipPath    = Join-Path $env:TEMP "hemtt_install.zip"
            $installDir = "$env:LOCALAPPDATA\Programs\hemtt"
            New-Item -ItemType Directory -Force -Path $installDir | Out-Null

            Write-Host "    Downloading $($asset.name)..." -ForegroundColor DarkGray
            Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -UseBasicParsing
            Expand-Archive -Path $zipPath -DestinationPath $installDir -Force
            Remove-Item $zipPath -ErrorAction SilentlyContinue

            $userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
            if ($userPath -notlike "*$installDir*") {
                [System.Environment]::SetEnvironmentVariable("PATH", "$userPath;$installDir", "User")
                $env:PATH += ";$installDir"
            }

            if (Test-Command "hemtt") {
                $hemttver = & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1
                Write-OK "HEMTT installed from GitHub: $hemttver"
            } else {
                Write-Warn "HEMTT extracted to $installDir but PATH needs refreshing."
                $script:needsRestart = $true
            }
        } catch {
            Write-Fail "GitHub download failed: $_"
            $script:manualInstalls.Add("HEMTT      ->  https://github.com/BrettMayson/HEMTT/releases")
        }
    }
}

# ---------------------------------------------------------------------------
# Arma 3 Tools (optional, needed for config binarization)
# ---------------------------------------------------------------------------
Write-Step "Checking Arma 3 Tools (required for config binarization)..."

function Get-SteamLibraryRoots {
    # Read all Steam library paths from libraryfolders.vdf
    $steamConfigPaths = @(
        "$env:ProgramFiles(x86)\Steam\steamapps\libraryfolders.vdf",
        "$env:ProgramFiles\Steam\steamapps\libraryfolders.vdf"
    )
    # Also check registry for the Steam install path
    try {
        $reg = [Microsoft.Win32.Registry]::CurrentUser
        $key = $reg.OpenSubKey("SOFTWARE\Valve\Steam")
        if ($key) {
            $steamPath = $key.GetValue("SteamPath")
            $key.Close()
            if ($steamPath) {
                $steamConfigPaths += (Join-Path $steamPath "steamapps\libraryfolders.vdf")
            }
        }
    } catch { }

    $roots = [System.Collections.Generic.List[string]]::new()
    foreach ($vdf in $steamConfigPaths) {
        if (-not (Test-Path $vdf)) { continue }
        # Parse "path" entries from the VDF - format: "path"  "D:\SteamLibrary"
        Get-Content $vdf | Where-Object { $_ -match '"path"\s+"([^"]+)"' } | ForEach-Object {
            $libPath = $Matches[1] -replace '\\\\', '\'
            $steamapps = Join-Path $libPath "steamapps\common"
            if (Test-Path $steamapps) { $roots.Add($steamapps) }
        }
    }
    return $roots
}

function Get-Arma3ToolsStatus {
    # Mirror exactly what SConstruct's arma3ToolsPath() does:
    # Read the 'path' value from the registry, derive the tools root via dirname,
    # and check it's a valid directory. SConstruct does not require CfgConvert.exe
    # to exist — it only checks os.path.isdir(tools). Match that behaviour.
    try {
        $reg = [Microsoft.Win32.Registry]::LocalMachine
        foreach ($keyPath in @(
            "SOFTWARE\Wow6432Node\Bohemia Interactive\AddonBuilder",
            "SOFTWARE\Bohemia Interactive\AddonBuilder"
        )) {
            $key = $reg.OpenSubKey($keyPath)
            if ($key) {
                $addonBuilderDirOrExe = $key.GetValue("path")
                $key.Close()
                if ($addonBuilderDirOrExe) {
                    # SConstruct: tools = os.path.dirname(addon_builder_path)
                    # dirname of a directory path returns its parent.
                    $toolsRoot = Split-Path $addonBuilderDirOrExe -Parent
                    if (Test-Path $toolsRoot -PathType Container) { return "Registered" }
                }
                # Key exists but 'path' value not yet written = AddonBuilder has never been run
                break
            }
        }
    } catch { }

    # Check Steam library for AddonBuilder executable on disk
    # (handles fresh install where AddonBuilder has never been run)
    foreach ($root in (Get-SteamLibraryRoots)) {
        $addonBuilderExe = Join-Path $root "Arma 3 Tools\AddonBuilder\AddonBuilder.exe"
        if (Test-Path $addonBuilderExe) { return "Installed" }
    }

    return "NotFound"
}

$a3tStatus = Get-Arma3ToolsStatus

if ($a3tStatus -eq "Registered") {
    Write-OK "Arma 3 Tools found and registered."
} elseif ($a3tStatus -eq "Installed") {
    Write-Warn "Arma 3 Tools is installed but not yet registered."
    Write-Host ""
    Write-Host "    The registry entry that tells the build where CfgConvert is has not been written yet." -ForegroundColor Yellow
    Write-Host "    This script can write it directly - no need to launch any tools manually." -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "    Would you like to register Arma 3 Tools now? [Y/n]"
    if ($response -eq '' -or $response -match '^[Yy]') {
        $toolsFolder = Get-SteamLibraryRoots | ForEach-Object { Join-Path $_ "Arma 3 Tools" } | Where-Object { Test-Path (Join-Path $_ "AddonBuilder\AddonBuilder.exe") } | Select-Object -First 1
        $addonBuilderDir = if ($toolsFolder) { Join-Path $toolsFolder "AddonBuilder" } else { $null }
        if ($addonBuilderDir -and (Test-Path $addonBuilderDir)) {
            # Write the registry values directly.
            # HKLM\AddonBuilder is used by SConstruct (CfgConvert check).
            # HKCU\binarize is used by HEMTT (binarize_x64.exe check).
            try {
                $reg = [Microsoft.Win32.Registry]::LocalMachine
                $key = $reg.OpenSubKey("SOFTWARE\Wow6432Node\Bohemia Interactive\AddonBuilder", $true)
                if (-not $key) {
                    $key = $reg.CreateSubKey("SOFTWARE\Wow6432Node\Bohemia Interactive\AddonBuilder")
                }
                $key.SetValue("path", $addonBuilderDir)
                $key.Close()

                # HEMTT reads HKCU\Software\Bohemia Interactive\binarize -> path
                # and checks for binarize_x64.exe in that folder.
                $binarizeDir = Join-Path $toolsFolder "Binarize"
                $hkcu = [Microsoft.Win32.Registry]::CurrentUser
                $bKey = $hkcu.OpenSubKey("Software\Bohemia Interactive\binarize", $true)
                if (-not $bKey) {
                    $bKey = $hkcu.CreateSubKey("Software\Bohemia Interactive\binarize")
                }
                $bKey.SetValue("path", $binarizeDir)
                $bKey.Close()

                Write-Host "    Registry entries written (SConstruct + HEMTT)." -ForegroundColor DarkGray
            } catch {
                Write-Warn "Could not write registry: $_"
            }
            if ((Get-Arma3ToolsStatus) -eq "Registered") {
                Write-OK "Arma 3 Tools registered successfully."
            } else {
                Write-Warn "Registration check failed - CfgConvert.exe may be missing from the Arma 3 Tools installation."
                $script:arma3ToolsInstalling = $true
                $script:manualInstalls.Add("Arma 3 Tools -> Open Arma 3 Tools from Steam to complete registration, then re-run this script")
            }
        } else {
            Write-Host "    Could not locate AddonBuilder folder in Steam libraries." -ForegroundColor Yellow
            $script:arma3ToolsInstalling = $true
            $script:manualInstalls.Add("Arma 3 Tools -> Open Arma 3 Tools from Steam to complete registration, then re-run this script")
        }
    } else {
        Write-Host "    Skipping. Open Arma 3 Tools from Steam before building." -ForegroundColor DarkGray
        $script:manualInstalls.Add("Arma 3 Tools -> Open Arma 3 Tools from Steam to complete registration, then re-run this script")
    }
} else {
    Write-Warn "Arma 3 Tools not found. This is required to binarize configs during the build."
    Write-Host ""
    Write-Host "    Arma 3 Tools is a free Steam application (App ID 233800)." -ForegroundColor Yellow
    Write-Host "    Install it via Steam, then re-run this script." -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "    Would you like to open the Steam install page now? [Y/n]"
    if ($response -eq '' -or $response -match '^[Yy]') {
        Write-Host "    Opening Steam install page for Arma 3 Tools..." -ForegroundColor DarkGray
        Start-Process "steam://install/233800"
        $script:arma3ToolsInstalling = $true
        Write-Host "    Once Steam finishes installing, open Arma 3 Tools once, then re-run this script." -ForegroundColor Yellow
    } else {
        Write-Host "    Skipping. Install manually from:" -ForegroundColor DarkGray
        Write-Host "    https://store.steampowered.com/app/233800/Arma_3_Tools/" -ForegroundColor Cyan
        $script:manualInstalls.Add("Arma 3 Tools -> https://store.steampowered.com/app/233800/Arma_3_Tools/")
    }
}

# ---------------------------------------------------------------------------
# pre-commit git hooks
# ---------------------------------------------------------------------------
Write-Step "Installing pre-commit git hooks..."

if (-not (Test-Path ".git")) {
    Write-Warn "No .git directory found - skipping hook install."
} else {
    # Resolve pre-commit executable - may not be on PATH yet if just installed
    $preCommitExe = if (Test-Command "pre-commit") {
        "pre-commit"
    } else {
        # Check both system Scripts dir and user Scripts dir (pip install --user target)
        try {
            $candidateDirs = @(
                (& python -c "import sysconfig; print(sysconfig.get_path('scripts'))" 2>$null),
                (& python -c "import site, os; print(os.path.join(os.path.dirname(site.getusersitepackages()), 'Scripts'))" 2>$null)
            )
            $candidateDirs | ForEach-Object {
                $candidate = Join-Path $_ "pre-commit.exe"
                if ($_ -and (Test-Path $candidate)) { $candidate }
            } | Select-Object -First 1
        } catch { $null }
    }

    if (-not $preCommitExe) {
        Write-Warn "pre-commit not found - skipping hook install. Re-run setup after opening a new terminal."
        $script:needsRestart = $true
    } elseif (Test-Path ".git\hooks\pre-commit") {
        Write-OK "pre-commit hooks already installed."
    } else {
        try {
            $ErrorActionPreference = "Continue"
            & $preCommitExe install
            Write-OK "pre-commit hooks installed."
        } catch {
            Write-Warn "pre-commit hook install failed: $_"
        }
    }
}

# ---------------------------------------------------------------------------
# PATH audit — ensure every installed tool's directory is in User or Machine PATH
# ---------------------------------------------------------------------------
Write-Step "Auditing PATH..."

$script:pathFixed = $false

# Adds $dir to User PATH (HKCU) if it exists on disk but is absent from both
# User PATH and Machine PATH. Also updates $env:PATH for this session.
function Add-ToUserPath([string]$dir) {
    if (-not $dir) { return }
    $dir = $dir.TrimEnd('\')
    if (-not (Test-Path $dir)) { return }
    $machine = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    $user    = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if (($machine + ";" + $user) -notlike "*$dir*") {
        [System.Environment]::SetEnvironmentVariable("PATH", "$user;$dir", "User")
        if ($env:PATH -notlike "*$dir*") { $env:PATH += ";$dir" }
        Write-Host "    Fixed: added missing PATH entry: $dir" -ForegroundColor Yellow
        $script:pathFixed = $true
    }
}

# Python interpreter dir and Scripts dir (scons, pre-commit, pip live here)
if (Test-Python) {
    try {
        $pyExe = (Get-Command python -ErrorAction SilentlyContinue).Source
        if ($pyExe) { Add-ToUserPath (Split-Path $pyExe -Parent) }
        $scriptsDir = (& python -c "import sysconfig; print(sysconfig.get_path('scripts'))" 2>$null)
        if ($scriptsDir) { Add-ToUserPath $scriptsDir.Trim() }
    } catch { }
    # Python Launcher (py.exe)
    Add-ToUserPath "$env:LOCALAPPDATA\Programs\Python\Launcher"
}

# HEMTT — winget creates a symlink in WinGet\Links; GitHub fallback extracts to Programs\hemtt
foreach ($hemttDir in @(
    "$env:LOCALAPPDATA\Microsoft\WinGet\Links",
    "$env:LOCALAPPDATA\Programs\hemtt"
)) {
    if (Test-Path (Join-Path $hemttDir "hemtt.exe")) {
        Add-ToUserPath $hemttDir
        break
    }
}

# Git — its installer writes to Machine PATH; if git.exe exists on disk but
# isn't on PATH yet, add the cmd dir to User PATH as a recovery step
if (-not (Test-Command "git")) {
    foreach ($gitDir in @(
        "C:\Program Files\Git\cmd",
        "C:\Program Files (x86)\Git\cmd"
    )) {
        if (Test-Path (Join-Path $gitDir "git.exe")) {
            Add-ToUserPath $gitDir
            break
        }
    }
}

# Remove stale entries (directories that no longer exist on disk) from Machine PATH.
# This catches ghost entries left behind by uninstallers (e.g. C:\Python313\Scripts\
# after Python 3.13 is removed) that silently shadow valid User PATH entries.
try {
    $rawMachine = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    $cleanMachine = ($rawMachine -split ";") | Where-Object { -not $_ -or (Test-Path $_) }
    $cleanMachineStr = $cleanMachine -join ";"
    if ($cleanMachineStr -ne $rawMachine) {
        [System.Environment]::SetEnvironmentVariable("PATH", $cleanMachineStr, "Machine")
        Write-Host "    Fixed: removed stale entries from Machine PATH" -ForegroundColor Yellow
        $script:pathFixed = $true
    }
} catch {
    Write-Warn "Could not clean Machine PATH: $_"
}

if ($script:pathFixed) {
    Broadcast-EnvChange
    Refresh-Path
    Write-OK "PATH corrections applied."
}

# Check whether Explorer's cached PATH (inherited by this process at launch)
# matches the current registry. A mismatch means Explorer is holding a stale
# snapshot — VS Code and any app launched from the taskbar will not see the
# correct tools until Explorer is restarted.
$registryPath = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH","User")
$inheritedEntries = ($script:inheritedPath -split ";" | Where-Object { $_ } | Sort-Object)
$registryEntries  = ($registryPath         -split ";" | Where-Object { $_ } | Sort-Object)
$explorerStale    = (Compare-Object $inheritedEntries $registryEntries) -ne $null

if ($explorerStale) {
    Write-Host ""
    Write-Host "    Explorer's PATH cache is out of date. Apps launched from the" -ForegroundColor Yellow
    Write-Host "    taskbar (VS Code, Windows Terminal, etc.) won't see the correct" -ForegroundColor Yellow
    Write-Host "    tools until Explorer is restarted." -ForegroundColor Yellow

    # Warn about apps that will still carry a stale PATH even after Explorer
    # restarts — because they were already running and won't re-inherit.
    # The user must close and reopen them manually after the Explorer restart.
    $staleLaunchedApps = @(
        @{ Process = "GitHubDesktop";  Label = "GitHub Desktop" },
        @{ Process = "Code";           Label = "VS Code" },
        @{ Process = "WindowsTerminal";Label = "Windows Terminal" },
        @{ Process = "rider64";        Label = "JetBrains Rider" },
        @{ Process = "clion64";        Label = "CLion" },
        @{ Process = "idea64";         Label = "IntelliJ IDEA" },
        @{ Process = "pycharm64";      Label = "PyCharm" },
        @{ Process = "webstorm64";     Label = "WebStorm" },
        @{ Process = "goland64";       Label = "GoLand" },
        @{ Process = "devenv";         Label = "Visual Studio" },
        @{ Process = "eclipse";        Label = "Eclipse" },
        @{ Process = "sublime_text";   Label = "Sublime Text" },
        @{ Process = "atom";           Label = "Atom" },
        @{ Process = "notepad++";      Label = "Notepad++" },
        @{ Process = "ConEmu64";       Label = "ConEmu" },
        @{ Process = "Cmder";          Label = "Cmder" },
        @{ Process = "cmd";            Label = "Command Prompt (any open windows)" },
        @{ Process = "powershell";     Label = "PowerShell (any open windows)" },
        @{ Process = "pwsh";           Label = "PowerShell 7 (any open windows)" }
    ) | Where-Object { Get-Process -Name $_.Process -ErrorAction SilentlyContinue }

    if ($staleLaunchedApps) {
        Write-Host ""
        Write-Host "    The following apps are currently open. They each hold their own" -ForegroundColor Yellow
        Write-Host "    copy of the old PATH and must be closed and reopened after the" -ForegroundColor Yellow
        Write-Host "    Explorer restart to pick up the correct tools:" -ForegroundColor Yellow
        foreach ($app in $staleLaunchedApps) {
            Write-Host "      - $($app.Label)" -ForegroundColor Yellow
        }
    }

    Write-Host ""
    $restartExplorer = Read-Host "    Restart Explorer now? [Y/n]"
    if ($restartExplorer -eq '' -or $restartExplorer -match '^[Yy]') {
        Write-Host "    Restarting Explorer..." -ForegroundColor DarkGray
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 1500
        Start-Process explorer
        Write-Host ""
        Write-Host "    Explorer restarted. Close and reopen all terminals and apps" -ForegroundColor Green
        Write-Host "    to pick up the updated PATH." -ForegroundColor Green
        if ($staleLaunchedApps) {
            Write-Host "    These were detected as open:" -ForegroundColor Green
            foreach ($app in $staleLaunchedApps) {
                Write-Host "      - $($app.Label)" -ForegroundColor Green
            }
        }
    } else {
        Write-Warn "Explorer not restarted. Reboot or reopen affected apps manually to apply PATH changes."
        $script:needsRestart = $true
    }
} elseif (-not $script:pathFixed) {
    Write-OK "All PATH entries are correct."
}

# ---------------------------------------------------------------------------
# Final verification
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Verifying installed tools..." -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

$allOk = $true

$checks = @(
    @{ Name = "git";           Ver = { & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1 } },
    @{ Name = "python";        Ver = { & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1 } },
    @{ Name = "scons";         Ver = { & { $ErrorActionPreference = "Continue"; scons --version 2>&1 } | Select-Object -First 1 } },
    @{ Name = "hemtt";         Ver = { & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1 } },
    @{ Name = "pre-commit";    Ver = { & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1 } },
    @{ Name = "Arma 3 Tools";  Ver = { "Steam App ID 233800 (registered)" }; Check = { (Get-Arma3ToolsStatus) -eq "Registered" } }
)

foreach ($check in $checks) {
    $found = if ($check.ContainsKey("Check")) { & $check.Check } else { Test-Command $check.Name }
    if ($found) {
        $ver = & $check.Ver
        Write-Host ("  [OK]   {0,-14} {1}" -f $check.Name, $ver) -ForegroundColor Green
    } elseif ($check.Name -eq "Arma 3 Tools" -and $script:arma3ToolsInstalling) {
        Write-Host ("  [WAIT] {0,-14} Registration pending - re-run this script to confirm" -f $check.Name) -ForegroundColor Cyan
        $allOk = $false
    } elseif ($check.Name -eq "Arma 3 Tools" -and (Get-Arma3ToolsStatus) -eq "Installed") {
        Write-Host ("  [WARN] {0,-14} Installed but never launched - run AddonBuilder.exe once" -f $check.Name) -ForegroundColor Yellow
        $allOk = $false
    } else {
        Write-Host ("  [FAIL] {0,-14} NOT FOUND" -f $check.Name) -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""
if ($allOk -and $script:manualInstalls.Count -eq 0) {
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "  All tools verified. You are ready to build!" -ForegroundColor Green
    Write-Host "  Run:  scons" -ForegroundColor Green
    Write-Host "  See 'Development Build Commands.txt' for the full command reference." -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
} else {
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host "  Setup finished with issues." -ForegroundColor Yellow
    if ($script:manualInstalls.Count -gt 0) {
        Write-Host ""
        Write-Host "  The following tools require manual installation:" -ForegroundColor Yellow
        foreach ($item in $script:manualInstalls) {
            Write-Host "    $item" -ForegroundColor Yellow
        }
        Write-Host ""
        Write-Host "  After manual installs, re-run this script to verify." -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  If a tool shows [FAIL] but you just installed it, close" -ForegroundColor Yellow
    Write-Host "  this window, open a new terminal, and re-run the script." -ForegroundColor Yellow
    if ($script:arma3ToolsInstalling) {
        Write-Host ""
        Write-Host "  NOTE: Steam was opened to install Arma 3 Tools." -ForegroundColor Cyan
        Write-Host "  Once Steam finishes the download, run the setup again to verify:" -ForegroundColor Cyan
        Write-Host "  tools\Setup Development ENV.bat" -ForegroundColor Cyan
    }
    Write-Host "================================================================" -ForegroundColor Yellow
}

# Broadcast final PATH state to Explorer so any terminal opened after this
# point inherits the complete updated PATH without requiring a full logout.
Broadcast-EnvChange

# ---------------------------------------------------------------------------
# Offer to relaunch in a fresh terminal if PATH changes require it
# ---------------------------------------------------------------------------
if ($script:needsRestart) {
    Write-Host ""
    Write-Host "  Some tools were installed but won't appear on PATH until a new" -ForegroundColor Yellow
    Write-Host "  terminal session is started. The verification table above may show" -ForegroundColor Yellow
    Write-Host "  [FAIL] for tools that are actually installed." -ForegroundColor Yellow
    Write-Host ""
    $relaunchResponse = Read-Host "  Relaunch setup in a fresh window now to re-verify? [Y/n]"
    if ($relaunchResponse -eq '' -or $relaunchResponse -match '^[Yy]') {
        Write-Host "  Launching new setup window..." -ForegroundColor Cyan
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -File `"$PSCommandPath`" -SkipUpdateCheck" -Verb RunAs
        Stop-Process -Id $PID
    }
}

if ($script:arma3ToolsInstalling) {
    Write-Host ""
    Write-Host "  Waiting for Arma 3 Tools to be installed..." -ForegroundColor Cyan
    Write-Host "  Install it via Steam, then press Enter to re-verify." -ForegroundColor Cyan

    $a3tFound = $false
    while (-not $a3tFound) {
        Read-Host "  Press Enter once Arma 3 Tools is installed"
        $a3tFound = (Get-Arma3ToolsStatus) -ne "NotFound"
        if (-not $a3tFound) {
            Write-Host "  Still not detected. Make sure Steam has finished installing." -ForegroundColor Yellow
        }
    }

    Write-Host "  Arma 3 Tools detected! Relaunching setup to complete registration..." -ForegroundColor Green
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -File `"$PSCommandPath`" -SkipUpdateCheck" -Verb RunAs
    Stop-Process -Id $PID
}
