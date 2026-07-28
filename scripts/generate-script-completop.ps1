$ErrorActionPreference = 'Stop'
python (Join-Path $PSScriptRoot 'generate-scriptcompleto.py') @args
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
