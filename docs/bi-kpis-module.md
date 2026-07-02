# bi kpis module

Documento da Sprint 7 para o módulo bi kpis module.

## Visão geral

A implementação adiciona APIs protegidas, contratos públicos, domínio validado, migration PostgreSQL idempotente, worker de agregação e telas Bootstrap responsivas.

## Como testar

1. Execute `dotnet restore`.
2. Execute `dotnet build`.
3. Execute `dotnet test`.
4. Suba a API e acesse Swagger para os endpoints `/api/bi/*` e `/api/project/*`.

## Operação

Os dados são filtrados por tenant, as ações críticas registram feed operacional e os gráficos usam HTML, CSS, SVG e JavaScript puro, sem bibliotecas pesadas.
