$ErrorActionPreference = 'Stop'

function Fail($msg) {
  Write-Host ""
  Write-Host ("[SECURITY SCAN] FAIL: " + $msg) -ForegroundColor Red
  exit 1
}

function Ok($msg) {
  Write-Host ("[SECURITY SCAN] OK: " + $msg) -ForegroundColor Green
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$proj = Split-Path -Parent $root

Set-Location -Path $proj

# Files to scan (avoid huge binaries)
$include = @('*.md','*.html','*.css','*.ps1','*.csv','*.json','*.txt')

$patterns = @(
  # Common tokens/keys
  'ghp_[A-Za-z0-9]{30,}',
  'github_pat_[A-Za-z0-9_]{20,}',
  'sk-[A-Za-z0-9]{20,}',
  'xox[baprs]-[A-Za-z0-9-]{10,}',
  'AKIA[0-9A-Z]{16}',
  'AIza[0-9A-Za-z\-_]{35}',
  '-----BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY-----',
  'BEGIN\s+PRIVATE\s+KEY',
  # Generic secret assignments (best-effort)
  '(?i)\b(password|passwd|api[_-]?key|secret|token|client_secret|access[_-]?token|refresh[_-]?token)\s*[:=]'
)

$hits = @()
foreach ($glob in $include) {
  $files = Get-ChildItem -Path $proj -Recurse -File -Filter $glob -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\\\.git\\' }
  foreach ($f in $files) {
    if ($f.FullName -like '*\tools\security-scan.ps1') { continue }
    foreach ($p in $patterns) {
      try {
        $m = Select-String -Path $f.FullName -Pattern $p -AllMatches -Encoding UTF8 -ErrorAction SilentlyContinue
        if ($m) {
          foreach ($mm in $m) {
            $hits += ("{0}:{1}:{2}" -f $mm.Path, $mm.LineNumber, $mm.Line.Trim())
          }
        }
      } catch {
        # ignore unreadable files
      }
    }
  }
}

if ($hits.Count -gt 0) {
  Write-Host ""
  Write-Host "[SECURITY SCAN] Potential secret hits:" -ForegroundColor Yellow
  $hits | Select-Object -First 80 | ForEach-Object { Write-Host ("- " + $_) }
  Fail ("Found {0} potential secret hit(s). Fix or move to private/ and retry." -f $hits.Count)
}
Ok "No obvious secrets/tokens detected"

# Check for personal machine paths in public docs
$pathPatterns = @(
  'C:\\Users\\',
  '/Users/',
  '(?i)AppData\\',
  '(?i)OneDrive\\'
)
$docFiles = Get-ChildItem -Path (Join-Path $proj 'docs') -Recurse -File -Include '*.md' -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '\\docs\\SECURITY-PRIVACY\.md$' }
$docFiles += Get-ChildItem -Path $proj -File -Include 'README*.md','CONTRIBUTING.md' -ErrorAction SilentlyContinue

$pathHits = @()
foreach ($f in $docFiles) {
  foreach ($p in $pathPatterns) {
    $m = Select-String -Path $f.FullName -Pattern $p -AllMatches -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($m) {
      foreach ($mm in $m) { $pathHits += ("{0}:{1}:{2}" -f $mm.Path, $mm.LineNumber, $mm.Line.Trim()) }
    }
  }
}
if ($pathHits.Count -gt 0) {
  Write-Host ""
  Write-Host "[SECURITY SCAN] Personal machine path hits in docs:" -ForegroundColor Yellow
  $pathHits | Select-Object -First 80 | ForEach-Object { Write-Host ("- " + $_) }
  Fail ("Found {0} doc path hit(s). Replace with file:///C:/.../ style or generic placeholders." -f $pathHits.Count)
}
Ok "Docs do not contain obvious personal-machine paths"

exit 0

