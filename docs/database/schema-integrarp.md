# Schema canônico `integrarp`

Todas as relações de negócio, views, sequências, funções e triggers pertencem ao schema `integrarp` e são referenciadas explicitamente. `public` fica reservado a objetos de extensões oficiais; `integra`, `dbo` e configuração de `search_path` são proibidos.

A fonte de ordem é `database/migration_manifest.json`; o contrato derivado está em `database/schema_inventory.json`. O inventário registra origem, módulo, definição canônica, dependências e SHA-256. A qualificação é auditada pelo comando `dotnet run --project tools/IntegraRP.DatabaseInspector -- lint-schema-qualification`.
