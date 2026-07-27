$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
& python3 (Join-Path $root "scripts/generate-script-completop.py")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
