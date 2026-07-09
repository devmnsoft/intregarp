param([string]$Database="integrarp",[string]$HostName="localhost",[string]$User="postgres")
$ErrorActionPreference="Stop"
psql -h $HostName -U $User -d postgres -v ON_ERROR_STOP=1 -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$Database';"
psql -h $HostName -U $User -d postgres -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS $Database;"
psql -h $HostName -U $User -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE $Database;"
