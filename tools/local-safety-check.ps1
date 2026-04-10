$ErrorActionPreference = 'Stop'

function Fail($msg) {
  Write-Host ("[LOCAL SAFETY] FAIL: " + $msg) -ForegroundColor Red
  exit 1
}

function Ok($msg) {
  Write-Host ("[LOCAL SAFETY] OK: " + $msg) -ForegroundColor Green
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$proj = Split-Path -Parent $here
Set-Location -Path $proj

# 1) Ensure git is available and repository is initialized
try {
  git rev-parse --is-inside-work-tree *> $null
  if ($LASTEXITCODE -ne 0) { Fail "git repo not initialized" }
  Ok "Git repository detected"
} catch {
  Fail "Git not available or repo not initialized"
}

# 2) Run security scan (secrets + doc path)
pwsh -NoProfile -ExecutionPolicy Bypass -File ".\tools\security-scan.ps1"
if ($LASTEXITCODE -ne 0) { Fail "security-scan.ps1 failed" }
Ok "security-scan.ps1 passed"

exit 0
