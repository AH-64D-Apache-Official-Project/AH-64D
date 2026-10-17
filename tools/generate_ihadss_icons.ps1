# Renders the IHADSS virtual symbols (tools\ihadss\icons.html) to PAA textures, so they match the HTML page's drawing.
# Needs Chrome or Edge and HEMTT. Rerun after changing a symbol's drawing code.
$root   = Split-Path -Parent $PSScriptRoot
$page   = Join-Path $PSScriptRoot "ihadss\icons.html"
$dest   = Join-Path $root "addons\fza_ah64_ihadss\data\icons"
$temp   = Join-Path ([IO.Path]::GetTempPath()) "fza_ihadss_icons"
$chrome = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) { throw "Chrome or Edge not found" }

New-Item -ItemType Directory -Force $dest, $temp | Out-Null
# A fresh profile each run, or Chrome can serve a cached copy of the page
$chromeProfile = Join-Path ([IO.Path]::GetTempPath()) ("fza_ihadss_chrome_" + [guid]::NewGuid())
$dom = & $chrome --headless=new --disable-gpu --allow-file-access-from-files "--user-data-dir=$chromeProfile" --dump-dom ("file:///" + $page.Replace('\', '/')) | Out-String
if ($dom -notmatch '<pre id="out">(.*?)</pre>') { throw "No icon output from $page" }
$icons = $Matches[1] | ConvertFrom-Json

foreach ($icon in $icons.PSObject.Properties) {
    $png = Join-Path $temp ($icon.Name + ".png")
    $paa = Join-Path $dest ("ihadss_" + $icon.Name + "_ca.paa")
    [IO.File]::WriteAllBytes($png, [Convert]::FromBase64String($icon.Value.Substring($icon.Value.IndexOf(",") + 1)))
    # hemtt will not overwrite an existing file, and still exits 0
    Remove-Item $paa -ErrorAction SilentlyContinue
    & hemtt utils paa convert $png $paa | Out-Null
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $paa)) { throw "hemtt failed converting $png" }
    Write-Host "Wrote $paa"
}
Remove-Item -Recurse -Force $chromeProfile -ErrorAction SilentlyContinue
