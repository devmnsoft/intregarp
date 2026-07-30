# Matriz de CI v1.44

Legenda: **local verde** = comando executado com sucesso; **pendente** = nenhuma evidência real disponível.

| Check | Estado | Evidência |
|---|---|---|
| syntax | local verde | `bash -n`, `py_compile` e `node --check` |
| generator-determinism | local verde | gerador executado; aliases comparados byte a byte |
| schema-contract / schema-inventory | local verde | `python3 -m json.tool` |
| format, architecture, dotnet-linux, dotnet-windows, warnings-as-errors, razor | pendente | SDK .NET indisponível |
| manifest-validation, schema-qualification | pendente | executável .NET indisponível |
| bootstrap-contract | pendente | não homologado nesta execução |
| database-clean, database-idempotency, database-upgrade, database-preservation, migration-runner-real | pendente | PostgreSQL e SDK .NET indisponíveis |
| auth, customers, products, inventory, orders, process, tasks, evidence, notifications, audit-outbox, worker, dashboard, web-bff | pendente | testes .NET não executados |
| runtime-smoke, playwright, accessibility, visual-regression | pendente | runtime não iniciado |
| standalone-linux, standalone-windows | pendente | publish não executado |
| release-gate | pendente | não há workflow associado acessível |
