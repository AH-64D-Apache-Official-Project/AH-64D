# Regenerates the base64 copy of the IHADSS font that inline_ihadss_js.rhai embeds (Rhai hooks cannot read binary files)
$root = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $root "tools\ihadss\BMKApacheFont.ttf"
$dst  = Join-Path $root "addons\fza_ah64_ihadss\ui\font\BMKApacheFont.b64"
[IO.File]::WriteAllText($dst, [Convert]::ToBase64String([IO.File]::ReadAllBytes($src)))
Write-Host "Wrote $dst"
