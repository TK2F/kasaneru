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

# 1) Ensure no git remotes configured (local-only policy)
try {
  $remotes = git remote
  if ($LASTEXITCODE -ne 0) { Fail "git remote failed" }
  if ($remotes -and $remotes.Count -gt 0) {
    Fail ("Git remotes are configured: {0}. Remove them to keep local-only." -f ($remotes -join ', '))
  }
  Ok "No git remotes configured"
} catch {
  Fail "Git not available or repo not initialized"
}

# 2) Run security scan (secrets + doc path)
pwsh -NoProfile -ExecutionPolicy Bypass -File ".\tools\security-scan.ps1"
if ($LASTEXITCODE -ne 0) { Fail "security-scan.ps1 failed" }
Ok "security-scan.ps1 passed"

exit 0

