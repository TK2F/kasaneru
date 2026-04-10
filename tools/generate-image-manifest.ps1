# Generates images/manifest.json and images/manifest.js for LT overlay dock image picker.
# Run from repo root:  powershell -ExecutionPolicy Bypass -File .\tools\generate-image-manifest.ps1
# Or from tools/:      powershell -ExecutionPolicy Bypass -File .\generate-image-manifest.ps1

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$projRoot = Split-Path -Parent $here
$imgDir = Join-Path $projRoot 'images'
if (-not (Test-Path -LiteralPath $imgDir)) {
  New-Item -ItemType Directory -Path $imgDir | Out-Null
}
$extSet = @(
  '.png', '.jpg', '.jpeg', '.webp', '.svg', '.gif', '.bmp'
)
$files = Get-ChildItem -LiteralPath $imgDir -File -ErrorAction SilentlyContinue |
  Where-Object { $extSet -contains $_.Extension.ToLowerInvariant() } |
  ForEach-Object { $_.Name } |
  Sort-Object

$obj = [ordered]@{
  version = 1
  files   = @($files)
}
# UTF-8 without BOM (browser-friendly)
$json = ($obj | ConvertTo-Json -Compress -Depth 5)
$outPath = Join-Path $imgDir 'manifest.json'
[System.IO.File]::WriteAllText($outPath, $json, [System.Text.UTF8Encoding]::new($false))

# Also write a JS version to avoid XHR restrictions in some environments (e.g. file:// in CEF).
$jsObj = ($obj | ConvertTo-Json -Compress -Depth 5)
$js = "window.__LT_IMAGE_MANIFEST__ = $jsObj;"
$outJsPath = Join-Path $imgDir 'manifest.js'
[System.IO.File]::WriteAllText($outJsPath, $js, [System.Text.UTF8Encoding]::new($false))

Write-Host ("Wrote {0} entr(y/ies) to {1} and {2}" -f $files.Count, $outPath, $outJsPath)
