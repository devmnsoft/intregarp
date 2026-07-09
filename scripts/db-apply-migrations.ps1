param([string]$Database="integrarp",[string]$HostName="localhost",[string]$User="postgres",[string]$MigrationsPath="database/migrations")
$ErrorActionPreference="Stop"
Get-ChildItem $MigrationsPath -Filter *.sql | Sort-Object Name | ForEach-Object { psql -h $HostName -U $User -d $Database -v ON_ERROR_STOP=1 -f $_.FullName }
