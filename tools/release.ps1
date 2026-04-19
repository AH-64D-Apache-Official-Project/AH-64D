<#
.SYNOPSIS
    Builds a release and repackages the zip with the correct inner folder name.
.DESCRIPTION
    Runs hemtt release, then rewrites the zip archives to rename the inner mod folder:
      - Inner folder: @fza_ah64 -> @fza_ah64_apache_longbow
    The zip file rename (fza_ah64-*.zip -> ah64-*.zip) is handled automatically
    by the HEMTT post_release hook (.hemtt/hooks/post_release/rename_zips.rhai).
    Run from anywhere: .\tools\release.ps1
#>
param(
    [switch]$NoArchive
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path $PSScriptRoot -Parent
Push-Location $projectRoot

try {

# Run HEMTT release (the post_release hook renames fza_ah64-*.zip -> ah64-*.zip)
$hemttArgs = @("release")
if ($NoArchive) { $hemttArgs += "--no-archive" }
& hemtt @hemttArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "hemtt release failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

if ($NoArchive) {
    Write-Host "Skipping zip repackaging (--no-archive)"
    exit 0
}

# Repackage zips to rename inner folder (zip files already renamed by HEMTT hook)
$releasesDir = Join-Path $projectRoot "releases"
$oldFolder   = "@fza_ah64"
$newFolder   = "@fza_ah64_apache_longbow"

foreach ($zip in Get-ChildItem "$releasesDir\ah64-*.zip") {
    $tempDir = Join-Path $releasesDir "_repack_temp"
    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }

    Write-Host "Repackaging $($zip.Name) (renaming inner folder)..."
    Expand-Archive -Path $zip.FullName -DestinationPath $tempDir -Force

    # Rename inner folder
    $oldPath = Join-Path $tempDir $oldFolder
    if (Test-Path $oldPath) {
        Rename-Item $oldPath $newFolder
    }

    # Re-zip in place (filename is already correct from the HEMTT hook)
    Remove-Item $zip.FullName -Force
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zip.FullName -CompressionLevel Optimal

    # Clean up
    Remove-Item $tempDir -Recurse -Force
    Write-Host "  -> $($zip.Name) ($newFolder)"
}

Write-Host "Release complete."

} finally {
    Pop-Location
}
