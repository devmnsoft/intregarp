# Matriz de workflows — IntegraRP v1.43

`Bloqueado pelo ambiente` significa que o comando depende de .NET, PostgreSQL, Windows, browser ou GitHub Actions indisponíveis localmente. Não significa aprovação.

| Job auditado | Estado anterior / primeira causa acessível | Arquivo/linha lógica | Correção ou regressão v1.43 | Nova execução / estado final |
|---|---|---|---|---|
| format | Log remoto inacessível (proxy 403) | `.github/workflows/ci.yml` | job independente `dotnet format --verify-no-changes` | Bloqueado pelo ambiente |
| dotnet-linux | Log remoto inacessível | solução .NET | restore/build/test Release | Bloqueado pelo ambiente |
| dotnet-windows | Log remoto inacessível | solução .NET | build/test em `windows-latest` | Bloqueado pelo ambiente |
| warnings-as-errors | Log remoto inacessível | solução .NET | `/p:TreatWarningsAsErrors=true` | Bloqueado pelo ambiente |
| architecture | Log remoto inacessível | testes Architecture | filtro continua falhando quando encontra zero testes | Bloqueado pelo ambiente |
| manifest-validation | contrato ainda era v1.40 | `database/migration_manifest.json` | migration 0047 com SHA-256 | Validação Python passou; .NET bloqueado |
| schema-qualification | falsos positivos de palavras de controle | `tools/IntegraRP.DatabaseInspector/Program.cs` | IF/THEN/ELSE/END/RETURNING classificados como permitidos; relatório v143 | Bloqueado pelo .NET |
| bootstrap-contract | contrato verificava principalmente presença | `.github/workflows/ci.yml` | distribuição local e licenças preservadas | Execução completa bloqueada |
| database-clean | `processo_definicao_id` ausente antes do índice | `0001` → `0003` (congeladas) | reconciliação 0047 promovida pelo gerador | PostgreSQL bloqueado |
| database-idempotency | mesma causa de instalação inicial | scripts canônicos | geração determinística e aliases idênticos | PostgreSQL bloqueado |
| database-upgrade | snapshot anterior usava comparação textual insegura | workflow v1.42 | contrato v1.43 explicita migration 47 | PostgreSQL bloqueado |
| database-preservation | sentinela cobria apenas tenant | workflow v1.42 | gate permanece obrigatório | PostgreSQL bloqueado |
| migration-runner-real | instalação parava no contrato de processos | migrations 0001/0003 | migration aditiva e checksum no manifesto | .NET/PostgreSQL bloqueados |
| standalone-linux | Log remoto inacessível | scripts standalone | check obrigatório mantido | .NET bloqueado |
| standalone-windows | Log remoto inacessível | scripts standalone | check obrigatório mantido | Windows/.NET bloqueados |
| auth | Log remoto inacessível | testes Auth | coberto por suíte existente | .NET bloqueado |
| web-bff | Log remoto inacessível | testes BFF/ApiClient | job obrigatório mantido | .NET bloqueado |
| customers | Log remoto inacessível | testes Customer | agregado em `commercial-domain` | .NET bloqueado |
| products | Log remoto inacessível | testes Product | agregado em `commercial-domain` | .NET bloqueado |
| inventory | Log remoto inacessível | testes Inventory | agregado em `commercial-domain` | .NET bloqueado |
| orders | Log remoto inacessível | testes Order | agregado em `commercial-domain` | .NET bloqueado |
| tasks | Log remoto inacessível | testes Task | suíte histórica preservada | .NET bloqueado |
| evidence | Log remoto inacessível | testes Evidence | suíte histórica preservada | .NET bloqueado |
| audit-outbox | Log remoto inacessível | testes Outbox | agregado em `outbox-worker` | .NET bloqueado |
| worker | Log remoto inacessível | testes Worker/Handler | `outbox-worker` obrigatório | .NET bloqueado |
| playwright | job era filtro sem runtime demonstrado | workflow v1.42 | permanece obrigatório no gate; requer run remoto real | Bloqueado pelo ambiente |
| accessibility | busca de strings não era axe | workflow v1.42 | não pode ser homologado por busca textual | Bloqueado; pendência real |
| visual-regression | existência de arquivo era aceita | workflow v1.42 | não pode ser homologado por existência de pasta | Bloqueado; pendência real |
| release-gate | dependências v1.42 divergiam da lista v1.43 | `.github/workflows/ci.yml` | depende de todos os 29 jobs obrigatórios | Aguardando GitHub Actions |

## Jobs adicionais obrigatórios v1.43

`syntax`, `schema-contract`, `schema-inventory`, `generator-determinism`, `razor`, `database-object-validation`, `commercial-domain`, `commercial-api`, `outbox-worker`, `runtime-smoke`, `security` e `diagnostic-artifacts` estão declarados no workflow. `diagnostic-artifacts` usa `if: always()` apenas para coleta e não representa sucesso.
