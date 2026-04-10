$ErrorActionPreference = 'Stop'

function Fail($msg) {
  Write-Host ("[pre-commit] FAIL: " + $msg) -ForegroundColor Red
  exit 1
}

function Ok($msg) {
  Write-Host ("[pre-commit] " + $msg) -ForegroundColor Green
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$proj = Split-Path -Parent $here
$gitDir = Join-Path $proj '.git'
if (-not (Test-Path -LiteralPath $gitDir)) {
  Fail ".git not found. Run 'git init' in the project root first."
}

$hooksDir = Join-Path $gitDir 'hooks'
if (-not (Test-Path -LiteralPath $hooksDir)) {
  New-Item -ItemType Directory -Path $hooksDir | Out-Null
}

$scanRel = '.\tools\security-scan.ps1'

function WriteUtf8NoBom($path, $text) {
  [System.IO.File]::WriteAllText($path, $text, [System.Text.UTF8Encoding]::new($false))
}

# Git for Windows reliably picks up .cmd hooks.
$hookCmdPath = Join-Path $hooksDir 'pre-commit.cmd'
$hookCmd = @"
@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "$scanRel"
if not "%ERRORLEVEL%"=="0" exit /b %ERRORLEVEL%
exit /b 0
"@
WriteUtf8NoBom $hookCmdPath $hookCmd

Ok "Installed git pre-commit hook: $hookCmdPath"
Ok "It runs: $scanRel"
Ok "Note: .git/hooks is local-only (not committed)."

