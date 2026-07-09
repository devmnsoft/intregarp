$ErrorActionPreference="Stop"
$files=Get-ChildItem database/migrations -Filter *.sql | Sort-Object Name
$dups=$files | Group-Object { $_.Name.Substring(0,4) } | Where-Object Count -gt 1
if($dups | Where-Object Name -ne '0014'){ throw "Duplicidade nova de migrations: $($dups.Name -join ',')" }
foreach($f in $files){ if($f.Name -notmatch '^\d{4}_[a-z0-9_]+\.sql$'){ throw "Nome inválido: $($f.Name)" }; $s=Get-Content $f.FullName -Raw; if($s -match 'public\.|integra\.'){ throw "Schema proibido em $($f.Name)" }; if($s -notmatch 'integrarp\.'){ throw "Schema integrarp ausente em $($f.Name)" } }
python -m json.tool database/migration_manifest.json | Out-Null
Write-Host "Migrations validadas. Duplicidade histórica 0014 documentada."
