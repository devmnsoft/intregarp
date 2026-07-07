$ErrorActionPreference='Stop'
$files=Get-ChildItem "$PSScriptRoot/../database/migrations" -Filter '*.sql'
$numbers=@{}
foreach($f in $files){ if($f.Name -notmatch '^\d{4}_[a-z0-9_]+\.sql$'){ throw "Migration fora do padrão: $($f.Name)" }; $n=$f.Name.Substring(0,4); if($numbers[$n]){ Write-Warning "Número duplicado histórico: $n" } ; $numbers[$n]=$true; $s=Get-Content $f.FullName -Raw; if($s -match 'public\.' -or $s -match 'integra\.'){ throw "Schema proibido em $($f.Name)" }; if($s -notmatch 'integrarp\.'){ throw "Migration sem integrarp: $($f.Name)" } }
if(-not (Test-Path "$PSScriptRoot/../database/migration_manifest.json")){ throw 'migration_manifest.json ausente' }
