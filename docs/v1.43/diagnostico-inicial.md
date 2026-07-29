# Diagnóstico inicial — IntegraRP v1.43

## Governança

- **SHA-base local:** `239dbc29d4d7b7e2593ac7eac6ad43f9bc068a66`.
- A ancestralidade exigida foi confirmada localmente e a branch `codex/v143-convergencia-executavel-banco-ci` foi criada sem trabalhar na `main`.
- `git fetch origin --prune` foi executado antes das alterações, mas o proxy do ambiente respondeu `CONNECT tunnel failed, response 403`. Portanto, runs e logs remotos do GitHub Actions não ficaram acessíveis nesta execução.
- Nenhuma migration de `0001` a `0046` foi alterada.

## Primeira causa raiz reproduzível

O instalador v1.42 concatenava as migrations históricas. A `0001` criava `integrarp.processo_versao` no formato genérico, sem `processo_definicao_id`; por usar `CREATE TABLE IF NOT EXISTS`, a `0003` não convergia a tabela e tentava criar `ix_processo_versao_tenant_definicao` sobre uma coluna inexistente.

A v1.43 adiciona a migration aditiva `0047_v143_convergencia_executavel.sql` e o gerador promove essa reconciliação imediatamente após `0001` no instalador canônico. Colunas são criadas antes dos índices. Quando uma associação obrigatória não pode ser inferida, o upgrade falha explicitamente com tabela, coluna, quantidade incompatível e orientação, sem inventar dados.

## Portão Zero local

O contêiner não contém `dotnet`, `psql`, `pg_dump`, Docker ou GitHub CLI. Por isso, build, testes .NET, PostgreSQL 16, runtime e browser não são homologados neste documento. Os checks locais executáveis foram sintaxe shell/Python/JavaScript, geração determinística, identidade dos aliases, JSON e invariantes Git. A indisponibilidade é uma limitação real, não um resultado verde.

## Escopo implementado nesta execução

1. Convergência executável do contrato de processos e metadado v1.43.
2. Geração determinística dos dois scripts canônicos e inventário v1.43.
3. Contrato estruturado do schema e allowlist vazia/auditável.
4. Validador canônico atualizado para v1.43/47 migrations.
5. Workflow v1.43 com jobs obrigatórios e `release-gate` dependente de todos eles.

## Pendências de homologação remota

O PR deve permanecer **Draft**. Sem acesso ao GitHub e sem toolchain local, não há evidência legítima para declarar o `release-gate` verde, PostgreSQL homologado, runtime real, Playwright/axe ou regressão visual aprovados.
