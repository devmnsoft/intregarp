# IntegraRP

SaaS ERP/BPMN inteligente da **Valora Group & MNSoft**. Posicionamento: “Do pedido ao faturamento, tudo integrado, comunicado e medido.”

## Arquitetura

Solution `IntegraRP.sln` com projetos separados: `Api`, `Web`, `Application`, `Domain`, `Infrastructure`, `Contracts`, `Worker` e `Tests`. O Domain não referencia infraestrutura. Controllers usam Application por interfaces. O Web é Bootstrap 5, JavaScript puro e não acessa banco.

## Como rodar

```bash
docker compose up -d
dotnet restore
dotnet build
dotnet run --project src/IntegraRP.Api
dotnet run --project src/IntegraRP.Web
```

URLs locais: Swagger em `https://localhost:7001/swagger`; Web em `https://localhost:5001`; pgAdmin em `http://localhost:8081`.

> Windows sem Docker: instale PostgreSQL, crie o banco `integrarp` e ajuste `ConnectionStrings:IntegraRP` em `appsettings.Development.json` ou variável de ambiente.

## Migrations

Script manual: `database/migrations/0001_initial_integrarp.sql`. Ele cria `pgcrypto`, schema `integrarp`, tabelas com UUID, auditoria, soft delete, JSONB, índices, triggers e views. A API pode executar migrations em desenvolvimento com `IntegraRP:RunMigrations=true` via `PostgresMigrationRunner`, que usa `pg_advisory_lock`, checksum SHA-256 e transação.

## Banco

Todas as tabelas do sistema usam `integrarp.nome_da_tabela`; nunca `public`. Tabelas operacionais possuem `tenant_id`, campos `criado_em`, `criado_por_usuario_id`, `atualizado_em`, `atualizado_por_usuario_id`, `excluido_em` e metadados JSONB.

## Logs e erros

A API usa `ILogger<T>`, `correlation_id` por request, middleware global de exceções e `ProblemDetails`. Use cases e repositórios devem retornar `Result<T>` para erros previsíveis e logar início/fim/erro.

## Segurança futura

A fundação inclui Tenant Middleware, opções JWT, contratos para RBAC/auditoria e tabelas para permissões. Autenticação completa, rate limiting, mascaramento e LGPD ficam como próximos passos documentados.

## Branch e commits

Trabalhar em `feature/fundacao-integrarp-saas`; commits pequenos por camada ou capacidade.

## Próximos passos

Implementar autenticação JWT, persistência real dos endpoints, políticas RBAC, outbox completo, cálculo de KPIs e componentes BPMN visuais.
