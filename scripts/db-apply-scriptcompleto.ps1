param([string]$Database='integrarp',[string]$HostName='localhost',[string]$User='postgres',[string]$Port='5432')
$ErrorActionPreference='Stop'
$root=Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
psql -h $HostName -p $Port -U $User -d postgres -v ON_ERROR_STOP=1 -tc "SELECT 1 FROM pg_database WHERE datname='$Database'" | Select-String 1 | Out-Null
if($LASTEXITCODE -ne 0){ psql -h $HostName -p $Port -U $User -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE $Database" }
psql -h $HostName -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -f "$root/database/scriptcompleto.sql"
psql -h $HostName -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -f "$root/database/scriptcompleto.sql"
& "$PSScriptRoot/db-validate-scriptcompleto.ps1" -Database $Database -HostName $HostName -User $User -Port $Port
