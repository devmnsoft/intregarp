$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$bashScript = Join-Path $root "scripts/generate-script-completop.sh"
if (Get-Command bash -ErrorAction SilentlyContinue) {
  bash $bashScript
  exit $LASTEXITCODE
}
throw "bash não encontrado. Execute scripts/generate-script-completop.sh em ambiente com bash ou WSL."
