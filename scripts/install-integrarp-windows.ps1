[CmdletBinding()]
param(
 [Alias('Host')][string]$DatabaseHost='localhost',[int]$Port=5432,[string]$Database='integrarp',[string]$AdminDatabase='postgres',
 [string]$Username='postgres',[string]$Password,[ValidateSet('Development','Pilot','Production','demo')][string]$InstallMode='Development',
 [switch]$ResetDatabase,[switch]$SeedDemo)
$ErrorActionPreference='Stop'
if(-not (Get-Command psql -ErrorAction SilentlyContinue)){ throw 'psql não encontrado no PATH.' }
if($Database -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'){ throw 'Nome de banco inválido.' }
if($InstallMode -eq 'Production'){
 foreach($name in 'INTEGRARP_BOOTSTRAP_ADMIN_EMAIL','INTEGRARP_BOOTSTRAP_ADMIN_PASSWORD','INTEGRARP_BOOTSTRAP_ADMIN_NAME'){
   if([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable($name))){ throw "$name é obrigatório em Production." }
 }
}
$env:PGPASSWORD=$Password; $env:PGOPTIONS="-c integrarp.install_mode=$InstallMode -c integrarp.seed_demo=$($SeedDemo.IsPresent.ToString().ToLowerInvariant())"
$common=@('-X','-h',$DatabaseHost,'-p',$Port,'-U',$Username,'--set','ON_ERROR_STOP=1')
& psql @common -d $AdminDatabase -c 'SELECT 1' | Out-Null; if($LASTEXITCODE){ throw 'Falha de conexão administrativa.' }
$exists=& psql @common -d $AdminDatabase -Atc "SELECT 1 FROM pg_database WHERE datname='$Database'"
if($ResetDatabase -and $exists -eq '1'){ & psql @common -d $AdminDatabase -c "DROP DATABASE `"$Database`" WITH (FORCE)"; $exists=$null }
if($exists -ne '1'){ & psql @common -d $AdminDatabase -c "CREATE DATABASE `"$Database`"" }
$root=Resolve-Path (Join-Path $PSScriptRoot '..')
& psql @common -d $Database --file (Join-Path $root 'database/scriptcompleto.sql'); if($LASTEXITCODE){ throw 'Falha no instalador canônico.' }
& psql @common -d $Database --file (Join-Path $root 'database/validate_scriptcompleto.sql'); if($LASTEXITCODE){ throw 'Falha na validação final.' }
Write-Host "IntegraRP v1.60 instalado em ${DatabaseHost}:$Port/$Database (modo $InstallMode)."
if($InstallMode -ne 'Production'){ Write-Host 'URL: http://localhost:5000 | usuário: admin@integrarp.local | troca de senha obrigatória' }
