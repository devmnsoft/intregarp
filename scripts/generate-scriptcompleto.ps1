$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$bashScript = Join-Path $root "scripts/generate-scriptcompleto.sh"
if (Get-Command bash -ErrorAction SilentlyContinue) {
  bash $bashScript
  exit $LASTEXITCODE
}
throw "bash não encontrado. Execute scripts/generate-scriptcompleto.sh em ambiente com bash ou WSL."
