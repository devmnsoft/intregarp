# Matriz de correções do CI v1.42

Workflow anterior solicitado: `30455314705`. Acesso aos logs: **indisponível no ambiente (HTTP 403)**. “Não executado” não equivale a sucesso.

| Job | Status anterior | Primeira causa | Arquivo/linha | Correção | Regressão | Nova execução | Status final | Workflow | Limitação |
|---|---|---|---|---|---|---|---|---|---|
| dotnet-windows | Não consultado | Mesmo erro C# independente de SO | `NextBestAction.cs` | Sobrecarga válida | Build Windows pendente | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| dotnet-linux | Não consultado | Erro de compilação confirmado em `StartsWith` | `NextBestAction.cs` (validação de deep link) | Sobrecarga válida e testes de matriz | `V137ProductJourneyTests` | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| warnings-as-errors | Não consultado | CS8620 confirmado por inspeção | `ApiProxyController.cs` (encaminhamento de headers) | Cópia explícita de valores não nulos | Build com warnings pendente | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| manifest-validation | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| schema-qualification | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| database-clean | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| database-upgrade | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| database-idempotency | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| database-preservation | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| migration-runner-real | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| bootstrap-contract | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| accessibility | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| standalone-linux | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| architecture | Não consultado | Rotas concorrentes confirmadas | `NotificationsController.cs`; `V11Controllers.cs` | Rota histórica isolada sob `/api/legacy` | Análise/build pendente | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| auth | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| customers | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| products | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| inventory | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| orders | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| tasks | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| audit-outbox | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| worker | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| web-bff | Não consultado | Rotas concorrentes confirmadas | `NotificationsController.cs`; `V11Controllers.cs` | Rota histórica isolada sob `/api/legacy` | Análise/build pendente | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| playwright | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| visual-regression | Não consultado | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não determinada sem logs | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
| release-gate | Não consultado | Dependências não executadas | `.github/workflows/ci.yml` | Nenhum gate foi ignorado | Actions pendente | Não executada | Não homologado | 30455314705 | Sem GitHub/.NET/PostgreSQL |
