param([string]$Database="integrarp",[string]$HostName="localhost",[string]$User="postgres",[string]$ScriptPath="database/scriptcompleto.sql")
$ErrorActionPreference="Stop"
psql -h $HostName -U $User -d postgres -v ON_ERROR_STOP=1 -c "SELECT 'CREATE DATABASE $Database' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$Database')\gexec"
psql -h $HostName -U $User -d $Database -v ON_ERROR_STOP=1 -f $ScriptPath
