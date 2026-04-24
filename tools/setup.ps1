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

# Snapshot PATH at startup. Compared at the end to detect whether the registry
# was updated during this run — if so, open terminals won't see the new tools.
$script:pathRegistryUpdated = $false

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
        $gitverBefore = & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1
        Write-Host "    Checking for Git update..." -ForegroundColor DarkGray
        Try-Winget @("upgrade", "--id", "Git.Git", "--silent",
            "--accept-package-agreements", "--accept-source-agreements") | Out-Null
        Refresh-Path
        $gitver = & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1
        if ($gitver -ne $gitverBefore) { Write-OK "Git updated: $gitver" } else { Write-OK "Git up to date: $gitver" }
    } else {
        $gitver = & { $ErrorActionPreference = "Continue"; git --version 2>&1 } | Select-Object -First 1
        Write-OK "Found: $gitver"
    }
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
    if ($script:checkUpdates) {
        $pyverBefore = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
        Write-Host "    Checking for Python update..." -ForegroundColor DarkGray
        # Detect the currently installed minor version and upgrade that specific package
        $currentMinor = & { $ErrorActionPreference = "Continue"; python -c "import sys; print(sys.version_info.minor)" 2>&1 } | Select-Object -First 1
        if ($currentMinor -match '^\d+$') {
            Try-Winget @("upgrade", "--id", "Python.Python.3.$currentMinor", "--silent",
                "--accept-package-agreements", "--accept-source-agreements") | Out-Null
            Refresh-Path
        }
        $pyver = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
        if ($pyver -ne $pyverBefore) { Write-OK "Python updated: $pyver" } else { Write-OK "Python up to date: $pyver" }
    } else {
        $pyver = & { $ErrorActionPreference = "Continue"; python --version 2>&1 } | Select-Object -First 1
        Write-OK "Found: $pyver"
    }
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

        $sconsVerBefore = $null; $preCommitVerBefore = $null; $yamlVerBefore = $null
        if ($missing.Count -eq 0 -and -not $script:checkUpdates) {
            #Write-OK "pip packages already installed."
        } elseif ($missing.Count -eq 0 -and $script:checkUpdates) {
            $sconsVerBefore    = & { $ErrorActionPreference = "Continue"; scons --version 2>&1 } | Select-Object -First 1
            $preCommitVerBefore= & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1
            $yamlVerBefore     = & { $ErrorActionPreference = "Continue"; python -c "import yaml; print(yaml.__version__)" 2>&1 } | Select-Object -First 1
            Write-Host "    Checking for pip package updates..." -ForegroundColor DarkGray
            python -m pip install --upgrade pip --quiet
            python -m pip install --upgrade scons pre-commit pyyaml --quiet
        } else {
            Write-Host "    Installing missing packages: $($missing -join ', ')..." -ForegroundColor DarkGray
            python -m ensurepip 2>&1 | Out-Null
            # Upgrade pip first — outdated pip is a common cause of install failures.
            python -m pip install --upgrade pip --quiet 2>&1 | Out-Null
            # Install without --user: Python's own installer already puts its Scripts dir
            # on the User PATH, so scons/pre-commit will be found in any new terminal.
            # --user would put them in AppData\Roaming\...\Scripts which is NOT on User PATH.
            python -m pip install $missing --quiet 2>&1 | Out-Null
        }
        $sconsVer    = & { $ErrorActionPreference = "Continue"; scons --version 2>&1 } | Select-Object -First 1
        $preCommitVer= & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1
        $yamlVer     = & { $ErrorActionPreference = "Continue"; python -c "import yaml; print(yaml.__version__)" 2>&1 } | Select-Object -First 1
        if ($script:checkUpdates -and $missing.Count -eq 0) {
            if ($sconsVer -ne $sconsVerBefore) { Write-OK "scons updated:         $sconsVer" } else { Write-OK "scons up to date:      $sconsVer" }
            if ($preCommitVer -ne $preCommitVerBefore) { Write-OK "pre-commit updated:    $preCommitVer" } else { Write-OK "pre-commit up to date: $preCommitVer" }
            if ($yamlVer -ne $yamlVerBefore) { Write-OK "pyyaml updated:        $yamlVer" } else { Write-OK "pyyaml up to date:     $yamlVer" }
        } else {
            Write-OK "scons:      $sconsVer"
            Write-OK "pre-commit: $preCommitVer"
            Write-OK "pyyaml:     $yamlVer"
        }
    } catch {
        Write-Warn "pip install failed, retrying without --quiet..."
        try {
            $ErrorActionPreference = "Continue"
            python -m pip install --upgrade pip 2>&1 | Out-Null
            python -m pip install --upgrade scons pre-commit pyyaml
            $sconsVer    = & { $ErrorActionPreference = "Continue"; scons --version 2>&1 } | Select-Object -First 1
            $preCommitVer= & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1
            $yamlVer     = & { $ErrorActionPreference = "Continue"; python -c "import yaml; print(yaml.__version__)" 2>&1 } | Select-Object -First 1
            Write-OK "scons:      $sconsVer"
            Write-OK "pre-commit: $preCommitVer"
            Write-OK "pyyaml:     $yamlVer"
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
                    if (Test-Command "scons") {
                        $sconsVer = & { $ErrorActionPreference = "Continue"; scons --version 2>&1 } | Select-Object -First 1
                        Write-OK "scons:      $sconsVer"
                    }
                    if (Test-Command "pre-commit") {
                        $preCommitVer = & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1
                        Write-OK "pre-commit: $preCommitVer"
                    }
                } catch {
                    Write-Warn "Chocolatey threw an error: $_"
                }
            } else {
                Write-Host "    Chocolatey not found, skipping." -ForegroundColor DarkGray
            }
            # pyyaml has no Chocolatey package - retry pip for just pyyaml
            $yamlCheck2 = & { $ErrorActionPreference = "Continue"; python -c "import yaml; print('ok')" 2>&1 } | Select-Object -First 1
            if ($yamlCheck2 -ne 'ok') {
                Write-Host "    Retrying pip install for pyyaml..." -ForegroundColor DarkGray
                try {
                    $ErrorActionPreference = "Continue"
                    python -m pip install pyyaml 2>&1 | Out-Null
                    $yamlCheck3 = & { $ErrorActionPreference = "Continue"; python -c "import yaml; print('ok')" 2>&1 } | Select-Object -First 1
                    if ($yamlCheck3 -eq 'ok') {
                        $yamlVer = & { $ErrorActionPreference = "Continue"; python -c "import yaml; print(yaml.__version__)" 2>&1 } | Select-Object -First 1
                        Write-OK "pyyaml:     $yamlVer"
                    } else {
                        throw "import yaml failed after install"
                    }
                } catch {
                    Write-Fail "pyyaml: could not be installed automatically"
                    $script:manualInstalls.Add("PyYAML     ->  pip install pyyaml       (https://pypi.org/project/PyYAML/)")
                }
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
                $script:pathRegistryUpdated = $true
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
        $hemttverBefore = & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1
        Write-Host "    Checking for HEMTT update..." -ForegroundColor DarkGray
        Try-Winget @("upgrade", "--id", "BrettMayson.HEMTT", "--silent",
            "--accept-package-agreements", "--accept-source-agreements") | Out-Null
        Refresh-Path
        $hemttver = & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1
        if ($hemttver -ne $hemttverBefore) { Write-OK "HEMTT updated: $hemttver" } else { Write-OK "HEMTT up to date: $hemttver" }
    } else {
        $hemttver = & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1
        Write-OK "Found: $hemttver"
    }
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
                $script:pathRegistryUpdated = $true
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
        if ($script:checkUpdates) {
            Write-Host "    Running pre-commit autoupdate..." -ForegroundColor DarkGray
            try {
                $ErrorActionPreference = "Continue"
                # Let autoupdate print its own per-hook lines (shows name + old->new version)
                $autoupdateOut = & $preCommitExe autoupdate 2>&1
                $autoupdateOut | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                $preCommitVer2 = & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1
                # autoupdate prints "... -> ..." only when it actually bumps a version
                if ($autoupdateOut -match '->') {
                    Write-OK "pre-commit hooks updated ($preCommitVer2)"
                } else {
                    Write-OK "pre-commit hooks up to date ($preCommitVer2)"
                }
            } catch {
                Write-Warn "pre-commit autoupdate failed: $_"
            }
        } else {
            $preCommitVer2 = & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1
            Write-OK "pre-commit hooks ($preCommitVer2)"
        }
    } else {
        try {
            $ErrorActionPreference = "Continue"
            & $preCommitExe install
            $preCommitVer2 = & { $ErrorActionPreference = "Continue"; & $preCommitExe --version 2>&1 } | Select-Object -First 1
            Write-OK "pre-commit hooks installed ($preCommitVer2)"
        } catch {
            Write-Warn "pre-commit hook install failed: $_"
        }
    }
}

# ---------------------------------------------------------------------------
# Git hooks path (.githooks/) and build-number merge driver
# ---------------------------------------------------------------------------
Write-Step "Configuring git hooks and build-number merge driver..."

if (-not (Test-Path ".git")) {
    Write-Warn "No .git directory found - skipping git hooks configuration."
} else {
    # Point git at the repo's shared hooks folder
    try {
        $ErrorActionPreference = "Continue"
        git config core.hooksPath .githooks
        Write-OK "core.hooksPath set to .githooks"
    } catch {
        Write-Warn "Failed to set core.hooksPath: $_"
    }

    # Ensure the post-commit hook and merge driver script are executable
    # (required on Linux/macOS; harmless on Windows)
    $hookFiles = @(".githooks/post-commit", ".githooks/merge-version-number.py")
    foreach ($hookFile in $hookFiles) {
        if (Test-Path $hookFile) {
            try {
                $ErrorActionPreference = "Continue"
                $result = git update-index --chmod=+x $hookFile 2>&1
                if ($LASTEXITCODE -ne 0) {
                    # File not yet tracked - stage it first then set chmod
                    git add $hookFile 2>&1 | Out-Null
                    git update-index --chmod=+x $hookFile 2>&1 | Out-Null
                }
            } catch { }
        }
    }
    Write-OK "Hook files marked executable"

    # Register the build-number merge driver in the local git config.
    # The logic lives in .githooks/merge-version-number.py — keeping the config
    # value as a simple one-liner avoids PowerShell quoting issues entirely.
    try {
        $ErrorActionPreference = "Continue"
        git config merge.version-number-merge.name   "Version field auto-merge (minor/patch/build)"
        git config merge.version-number-merge.driver "python .githooks/merge-version-number.py %O %A %B"
        if ($LASTEXITCODE -eq 0) {
            Write-OK "version-number-merge driver registered"
        } else {
            Write-Warn "git config for merge driver returned non-zero exit code"
        }
    } catch {
        Write-Warn "Failed to register merge driver: $_"
    }
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
    @{ Name = "pre-commit";    Ver = { & { $ErrorActionPreference = "Continue"; pre-commit --version 2>&1 } | Select-Object -First 1 } },
    @{ Name = "pyyaml";        Ver = { & { $ErrorActionPreference = "Continue"; python -c "import yaml; print(yaml.__version__)" 2>&1 } | Select-Object -First 1 }; Check = { (& { $ErrorActionPreference = "Continue"; python -c "import yaml; print('ok')" 2>&1 } | Select-Object -First 1) -eq 'ok' } },
    @{ Name = "hemtt";         Ver = { & { $ErrorActionPreference = "Continue"; hemtt --version 2>&1 } | Select-Object -First 1 } }
)

foreach ($check in $checks) {
    $found = if ($check.ContainsKey("Check")) { & $check.Check } else { Test-Command $check.Name }
    if ($found) {
        $ver = & $check.Ver
        Write-Host ("  [OK]   {0,-14} {1}" -f $check.Name, $ver) -ForegroundColor Green
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
    Write-Host "================================================================" -ForegroundColor Yellow
}

# Broadcast final PATH state to Explorer so any terminal opened after this
# point inherits the complete updated PATH without requiring a full logout.
Broadcast-EnvChange

# Warn if PATH was changed during this run — open terminals won't see the new entries.
if ($script:pathRegistryUpdated) {
    Write-Host ""
    Write-Host "  PATH was updated during this run." -ForegroundColor Yellow
    Write-Host "  Close all open terminals (e.g. VS Code, Windows Terminal, git) and" -ForegroundColor Yellow
    Write-Host "  open a new one before running scons or hemtt." -ForegroundColor Yellow
}

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
