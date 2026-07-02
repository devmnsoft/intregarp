# IntegraRP / Integra Gestão Inteligente

**Valora Group & MNSoft** — “Do pedido ao faturamento, tudo integrado, comunicado e medido.”

O IntegraRP é uma fundação SaaS ERP/BPMN para conectar processos, pessoas, tarefas, módulos dinâmicos, IA operacional governada e KPIs vivos.

## Arquitetura

A solution `IntegraRP.sln` segue DDD + Clean Architecture:

- `IntegraRP.Domain`: entidades e enums sem dependência de ASP.NET, Dapper, Npgsql, API ou Web.
- `IntegraRP.Application`: interfaces, use cases e `Result<T>` para erros previsíveis.
- `IntegraRP.Infrastructure`: Dapper, Npgsql, migration runner, repositórios e serviços internos.
- `IntegraRP.Api`: controllers REST, Swagger, ProblemDetails, correlation_id e tenant middleware.
- `IntegraRP.Web`: ASP.NET Core MVC, Bootstrap 5, CSS/JS separados e consumo da API.
- `IntegraRP.Worker`: base para processamento de eventos, outbox e tarefas de fundo.

## Windows local sem Docker

1. Instale .NET 8 SDK e PostgreSQL.
2. Crie o banco `integrarp`.
3. Copie `.env.example` para `.env` se desejar documentar credenciais locais.
4. Ajuste `ConnectionStrings__IntegraRP` ou `appsettings.Development.json` sem gravar senha real.
5. Execute:

```powershell
scripts\setup-windows.cmd
scripts\build-windows.cmd
scripts\test-windows.cmd
scripts\run-api-windows.cmd
scripts\run-web-windows.cmd
scripts\run-worker-windows.cmd
```

## Docker

```powershell
docker compose up -d
```

URLs locais:

- API: `http://localhost:7001`
- Swagger: `http://localhost:7001/swagger`
- Web: `http://localhost:5001`
- pgAdmin: `http://localhost:8081`

Para resetar o ambiente local Docker:

```powershell
docker compose down -v
docker compose up -d
```

## Migrations

O script manual `database/migrations/0001_initial_integrarp.sql` é idempotente, cria `pgcrypto`, o schema único `integrarp`, `integrarp.schema_migrations`, tabelas BPMN, Studio, IA, eventos e Project Central, índices, triggers e `integrarp.vw_projeto_central_resumo`.

O Migration Runner em C# lê `IntegraRP:Database:MigrationsPath`, resolve caminhos por `Path.Combine`, usa `pg_advisory_lock`, calcula SHA-256, executa scripts pendentes em transação e falha se encontrar checksum divergente. Para executar automaticamente em desenvolvimento, use `IntegraRP:RunMigrations=true`; em produção o padrão é não executar automaticamente.

## BPMN / Integra Flow

A fundação inclui entidades de definição, versão, elemento, transição, instância, variável, tarefa, comentário, anexo, SLA, vínculo de evento e auditoria. A API expõe `/api/flow/processos`, `/api/flow/instancias` e `/api/flow/tarefas`. O Web oferece telas iniciais de Flow, Designer, Tarefas e Processos em execução.

## Integra Studio

O Studio cria módulos dinâmicos por metadados, sem gerar migrations por módulo. A sugestão inteligente é determinística por enquanto e inclui o exemplo obrigatório “Controle de Avarias”, campos, ações, KPIs e conexão BPMN.

## Integra AI governada

A IA não acessa banco diretamente. O orquestrador classifica intenção, valida permissão da ferramenta, executa somente tools internas, mascara dados, registra auditoria e abre fallback humano quando a ferramenta não é permitida. Não há integração com provedores externos nesta etapa.

## Tenant e schema

Toda operação usa `tenant_id` e os objetos de banco ficam no schema `integrarp`. Não devem ser criadas tabelas do sistema em outro schema.

## Padrões de código

- C# com nullable enable, async/await, `CancellationToken` e `ILogger<T>`.
- Controllers com `try/catch`, logs e `ProblemDetails`.
- Repositories e serviços externos com logs contextuais.
- CSS, JS, HTML, SQL e JSON formatados; sem minificação ou arquivos em uma linha.
- Uma classe por arquivo para novas classes de domínio.

## Troubleshooting

- Windows: confirme `dotnet --info`, `psql --version` e a connection string `Host=localhost`.
- Docker: confirme `docker compose ps`, logs do serviço `integrarp-api` e credenciais de `.env`.
