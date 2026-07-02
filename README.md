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

## Sprint 4 - Integra Flow Designer Web

O Integra Flow Designer Web permite desenhar processos BPMN operacionais sem editar JSON manualmente.

- Acesse `/flow/designer` para ver atalhos, templates e opções de criação.
- Acesse `/flow/designer/templates` para clonar modelos como Pedido ao Pós-venda, Emissão de Boletos, Recebimento de Notas Fiscais e Separação de Pedidos.
- Após clonar, abra `/flow/designer/versions/{versionId}` para adicionar etapas, gateways, transições, formulários e checklists.
- Use **Validar** para visualizar erros, warnings e infos antes de publicar.
- Use **Publicar** para registrar o processo validado no motor BPMN.
- Para criar um gateway, adicione o elemento Gateway, conecte duas saídas e marque uma transição como `always` ou fallback.
- Para formulário, configure campos `text`, `textarea`, `number`, `money`, `date`, `datetime`, `boolean`, `select`, `multiselect`, `user`, `sector`, `client`, `product`, `file`, `photo`, `signature`, `gps`, `json` ou `relation`.
- Para checklist, configure itens com código, título, obrigatoriedade e ordem.
- Depois de publicado, use **Iniciar teste** para validar uma instância operacional em ambiente seguro.

### Rodando no Windows

Execute `scripts\run-all-windows.ps1` ou rode API e Web separadamente com `scripts\run-api-windows.ps1` e `scripts\run-web-windows.ps1`.

### Rodando com Docker

Execute `docker compose up --build` e acesse a Web na porta configurada no `docker-compose.yml`.

## Sprint 6 - Faturamento, Connect, Outbox e MVP demonstrável

A Sprint 6 adiciona o fluxo demonstrável pedido → faturamento → título → boleto fake/log → notificação fake/log → outbox processado. Todo o armazenamento operacional novo usa o schema `integrarp` e os providers externos são simulados, sem secrets e sem chamadas reais de banco, WhatsApp, e-mail ou NF-e.

### Como usar Faturamento

1. Acesse `/billing` para ver o dashboard financeiro.
2. Acesse `/billing/invoices` para listar faturas.
3. Use `/billing/invoices/create` para criar uma fatura simplificada.
4. Abra uma fatura e use **Emitir** para concluir a emissão simplificada.
5. Use `/billing/titles` para acompanhar títulos em aberto, enviados e vencidos.
6. Abra um título e use **Gerar boleto fake** para registrar boleto/log com prefixo `FAKE-BOLETO`.
7. Use `/billing/fiscal-documents` para acompanhar referências fiscais fake/log com prefixo `FAKE-NFE`.

### Como gerar fatura a partir de pedido

Abra `/orders/{id}/billing`, clique em **Gerar fatura** e o Web consumirá `POST /api/billing/invoices/from-order/{orderId}`. A resposta mantém o vínculo com o pedido e cria um item demonstrativo para o MVP.

### Como gerar título e boleto fake

1. Na tela do pedido/faturamento, clique em **Gerar título** depois de gerar a fatura.
2. Clique em **Gerar boleto fake**.
3. O provider `FakeBoletoProvider` retorna link, linha digitável, código de barras e nosso número fake/log.

### Como configurar templates e mensagens

1. Acesse `/connect/templates`.
2. Crie templates usando variáveis simples como `{{cliente_nome}}`, `{{pedido_codigo}}`, `{{fatura_codigo}}`, `{{data_vencimento}}`, `{{valor_total}}` e `{{link_boleto}}`.
3. O renderer substitui somente variáveis informadas e marca variáveis ausentes como `[[variavel]]`.
4. Acesse `/connect/messages` para ver histórico fake/log de envios.

### Como enfileirar, processar e reprocessar outbox

1. Acesse `/connect/outbox`.
2. Use a tela de pedido/faturamento para enfileirar uma mensagem fake/log.
3. Clique em **Processar** na linha do outbox.
4. Eventos com erro podem ser reprocessados enquanto `tentativas < max_tentativas`.

### Worker

O Worker sobe em Windows e Docker como `BackgroundService`. A cada ciclo configurável por `IntegraRP:Worker:IntervalSeconds`, ele marca títulos vencidos e processa outbox pendente ou elegível para retry. Falhas são logadas e não derrubam o processo.

### Windows

```powershell
./scripts/build-windows.ps1
./scripts/run-api-windows.ps1
./scripts/run-web-windows.ps1
./scripts/run-worker-windows.ps1
```

### Docker

```bash
docker compose up --build
```

### Testes

```bash
dotnet restore IntegraRP.sln
dotnet build IntegraRP.sln
dotnet test IntegraRP.sln
```

### Demonstração MVP

Use o roteiro completo em `docs/mvp-demo-script.md` para demonstrar login, dashboard, pedido, Flow, faturamento, título, boleto fake, NF fake, mensagem fake/log, outbox e dashboards.
