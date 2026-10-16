# Converts fcrIcons/*.paa to committed icons_b64/*.b64 (Rhai hooks are text-only) — run when icon art changes

$ErrorActionPreference = "Stop"

$srcDir = "$PSScriptRoot\..\addons\fza_ah64_mpd\tex\fcrIcons"
$outDir = "$PSScriptRoot\..\addons\fza_ah64_fcr\ui\shared\icons_b64"

$hemtt = Get-Command hemtt -ErrorAction SilentlyContinue
if ($null -eq $hemtt) {
    Write-Error "hemtt not found on PATH. Install from https://hemtt.dev/"
    exit 1
}

$paaFiles = @(Get-ChildItem -Path $srcDir -Filter "*.paa" | Sort-Object Name)
if ($paaFiles.Count -eq 0) {
    Write-Error "No .paa files found in $srcDir"
    exit 1
}

$tmpDir = Join-Path $env:TEMP ("fcr_icon_b64_" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tmpDir | Out-Null

# Rebuild the output dir from scratch so deleted icons don't leave stale .b64 files
if (Test-Path $outDir) { Remove-Item -Path "$outDir\*.b64" -Force }
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$done = 0

try {
    foreach ($paa in $paaFiles) {
        # Lowercase keys: FzaIconTypes texture paths and disk filenames disagree on
        # case in places; JS atlas keys are case-sensitive, so both sides normalise.
        $key = ($paa.BaseName -replace '_ca$', '').ToLower()
        $png = Join-Path $tmpDir ($key + ".png")

        & hemtt utils paa convert $paa.FullName $png
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $png)) {
            Write-Error "hemtt utils paa convert failed for $($paa.Name)"
            exit 1
        }

        $bytes = [System.IO.File]::ReadAllBytes($png)
        $b64   = [System.Convert]::ToBase64String($bytes)
        [System.IO.File]::WriteAllText((Join-Path $outDir ($key + ".b64")), $b64, $utf8NoBom)
        $done++
    }
} finally {
    Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ("Generated " + $done + " .b64 icon files in " + $outDir) -ForegroundColor Green
