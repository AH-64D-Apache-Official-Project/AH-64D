# Builds the HDU monocle textures (tinted lens, and clear lens for the PNVS) from tools\ihadss\hdu_source_ca.paa.
# Needs Chrome or Edge and HEMTT.
$root   = Split-Path -Parent $PSScriptRoot
$tools  = Join-Path $PSScriptRoot "ihadss"
$dest   = Join-Path $root "addons\fza_ah64_ihadss\data\hdu"
$temp   = Join-Path ([IO.Path]::GetTempPath()) "fza_ihadss_hdu"
$chrome = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) { throw "Chrome or Edge not found" }

New-Item -ItemType Directory -Force $dest, $temp | Out-Null
Copy-Item (Join-Path $tools "hdu.html") $temp -Force
Remove-Item (Join-Path $temp "hdu_source.png") -ErrorAction SilentlyContinue
& hemtt utils paa convert (Join-Path $tools "hdu_source_ca.paa") (Join-Path $temp "hdu_source.png") | Out-Null
if ($LASTEXITCODE -ne 0) { throw "hemtt failed reading the source texture" }

$page = Join-Path $temp "hdu.html"
# A fresh profile each run, or Chrome can serve a cached copy of the page
$chromeProfile = Join-Path ([IO.Path]::GetTempPath()) ("fza_ihadss_chrome_" + [guid]::NewGuid())
$dom = & $chrome --headless=new --disable-gpu --allow-file-access-from-files "--user-data-dir=$chromeProfile" --dump-dom ("file:///" + $page.Replace('\', '/')) | Out-String
if ($dom -notmatch '<pre id="out">(.*?)</pre>') { throw "No output from $page" }
$images = $Matches[1] | ConvertFrom-Json

foreach ($image in $images.PSObject.Properties) {
    $png = Join-Path $temp ($image.Name + ".png")
    $suffix = if ($image.Name -eq "tinted") { "" } else { "_" + $image.Name }
    $paa = Join-Path $dest ("ihadss_hdu" + $suffix + "_ca.paa")
    [IO.File]::WriteAllBytes($png, [Convert]::FromBase64String($image.Value.Substring($image.Value.IndexOf(",") + 1)))
    # hemtt will not overwrite an existing file, and still exits 0
    Remove-Item $paa -ErrorAction SilentlyContinue
    & hemtt utils paa convert $png $paa | Out-Null
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $paa)) { throw "hemtt failed converting $png" }
    Write-Host "Wrote $paa"
}
Remove-Item -Recurse -Force $chromeProfile -ErrorAction SilentlyContinue
