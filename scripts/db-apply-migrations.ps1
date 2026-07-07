param([string]$Database='integrarp',[string]$HostName='localhost',[string]$User='postgres',[string]$Port='5432')
$ErrorActionPreference='Stop'
$root=Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Get-ChildItem "$root/database/migrations" -Filter '*.sql' | Sort-Object Name | ForEach-Object { psql -h $HostName -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -f $_.FullName }
