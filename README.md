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

## Integra Flow — BPMN Core Engine

A Sprint 3 adiciona o núcleo operacional do Integra Flow: definições, versões, elementos, transições, instâncias, tarefas humanas, SLA, auditoria, eventos de negócio e outbox fake/log. O seed idempotente “Pedido ao Pós-venda” usa o código `pedido_ao_pos_venda` e demonstra o fluxo do pedido recebido até pós-venda.

### Como executar

- Windows: execute `scripts\migrate-windows.ps1`, `scripts\build-windows.ps1` e `scripts\test-windows.ps1`.
- Docker: execute `docker compose up -d`; o migration runner aplica `database/migrations/0003_flow_bpmn_core.sql` quando habilitado.
- Swagger: acesse a API em `/swagger` e use as tags Flow Definitions, Flow Versions, Flow Instances, Flow Tasks e Flow Dashboard.

### Fluxo pela API

1. Crie uma definição em `POST /api/flow/definitions`.
2. Crie rascunho em `POST /api/flow/definitions/{definitionId}/versions`.
3. Adicione elementos e transições em `/api/flow/versions/{versionId}`.
4. Publique em `POST /api/flow/versions/{versionId}/publish`.
5. Inicie instância em `POST /api/flow/definitions/{definitionId}/start`.
6. Consulte tarefas em `GET /api/flow/tasks` e conclua em `POST /api/flow/tasks/{id}/complete`.
7. Consulte KPIs em `GET /api/flow/dashboard`.

Todas as consultas operacionais carregam `tenant_id`; auditoria registra ações críticas e o outbox registra notificações fake/log para nova tarefa, atraso, conclusão e erro de gateway.
