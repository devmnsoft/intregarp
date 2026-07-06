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

## Sprint 7 — BI, KPIs, Score Operacional e Project Central

A Sprint 7 adiciona a base de inteligência operacional do IntegraRP com dashboards de BI, KPIs vivos, score operacional e Project Central com Kanban, sprints, feed, métricas e importação/exportação JSON.

### Como usar BI

- Acesse `/bi` ou `/bi/executive` para o dashboard executivo.
- Use `/bi/flow`, `/bi/commercial`, `/bi/inventory`, `/bi/billing` e `/bi/connect` para dashboards por módulo.
- Use `/bi/kpis` para acompanhar definições e valores atuais de KPIs.
- Use `/bi/score` para interpretar o score operacional: positivo `>= 85`, neutro `>= 70`, negativo `>= 50` e crítico `< 50`.
- Recalcule KPIs e score pela API: `POST /api/bi/kpis/calculate-all` e `POST /api/bi/score/recalculate`.

### Como usar Project Central

- Acesse `/project` ou `/project/boards` para listar boards.
- Crie um board em `/project/boards/create` e habilite colunas padrão quando necessário.
- Abra `/project/boards/{id}/kanban` para criar, editar, mover e excluir cards com soft delete.
- Acompanhe sprints em `/project/boards/{id}/sprints`, métricas em `/project/boards/{id}/metrics` e feed em `/project/boards/{id}/feed`.
- Exporte e importe JSON em `/project/boards/{id}/import-export` ou pelos endpoints `POST /api/project/boards/{boardId}/export` e `POST /api/project/boards/{boardId}/import`.

### Windows, Docker e testes

- Windows: `dotnet restore`, `dotnet build` e `dotnet test`.
- Docker: `docker compose up --build`.
- Banco: execute as migrations em `/database/migrations`; a `0007_bi_kpis_project_central.sql` é idempotente e usa apenas o schema `integrarp`.

## Sprint 8 — Mobile Field App e Integra AI MVP

A Sprint 8 adiciona o aplicativo base Expo em `apps/IntegraRP.Mobile`, APIs REST mobile, Console IA Web, migration `0008_mobile_ai_mvp.sql` e worker para notificações/fallback fake.

### Rodar no Windows
1. Instale .NET SDK, Node.js LTS e Docker Desktop.
2. Execute `dotnet restore`, `dotnet build` e `dotnet test` na raiz.
3. Suba banco/API/Web/Worker com o fluxo Docker já existente do projeto.

### Rodar o Mobile
1. Entre em `apps/IntegraRP.Mobile`.
2. Configure `EXPO_PUBLIC_API_BASE_URL` apontando para a API.
3. Execute `npm install` e `npm run typecheck`.
4. Execute `npm start` e abra no Expo Go ou emulador.

### Uso mobile e IA
O app permite login com e-mail, senha e slug do tenant, dashboard resumido, minha fila, detalhe/execução de tarefa, evidências, GPS, assinatura, notificações e chat IA governado. Tokens usam `expo-secure-store`; não há segredo no app. A IA usa classificador rule-based, registry de tools seguras, auditoria e fallback humano sem integração externa real.

## Sprint 9 - Integra Studio Avançado

O Integra Studio Avançado cria módulos dinâmicos por metadados, mantendo DDD/Clean Architecture e banco PostgreSQL no schema `integrarp`.

### Como usar o Studio

1. Acesse `/studio` no Web.
2. Clique em **Criar módulo** ou use `/studio/smart-builder`.
3. Informe nome, código, ícone e cor.
4. Abra o builder em `/studio/modules/{id}/builder`.
5. Configure campos, ações, relacionamentos, BPMN, KPIs e catálogo semântico.
6. Publique o módulo e acesse `/dynamic/{moduleCode}`.

### Registros dinâmicos

- Listagem: `/dynamic/{moduleCode}`.
- Criação: `/dynamic/{moduleCode}/create`.
- Detalhe/histórico: `/dynamic/{moduleCode}/{recordId}`.

### BPMN, IA e KPIs

- BPMN é configurado por vínculos de evento/ação.
- IA só deve consultar módulos com `permite_ia` e catálogo semântico autorizado.
- KPIs dinâmicos usam tipos seguros como contagem, soma de campo e média, sem SQL arbitrário do usuário.

### Windows, Docker e testes

- Windows: execute `dotnet restore`, `dotnet build` e `dotnet test`.
- Docker: execute `docker compose up --build` quando o ambiente Docker estiver disponível.
- Banco: aplique `database/migrations/0009_studio_avancado_modulos_dinamicos.sql` após as migrations anteriores.

## Sprint 10 — Templates Operacionais, Distribuição e Campo

O IntegraRP agora inclui o catálogo **Templates Operacionais** para instalar o **Pacote Operação Distribuição** com módulos dinâmicos, processos BPMN, KPIs, formulários mobile, catálogo semântico de IA, mensagens e dashboards. Acesse `/operational/templates`, instale o pacote e acompanhe as instalações em `/operational/templates/installations`.

### Como usar

1. Execute as migrations, incluindo `database/migrations/0010_templates_operacionais_distribuicao_campo.sql`.
2. Suba API, Web e Worker com os scripts Windows ou Docker já existentes.
3. No Web, abra **Templates Operacionais** e instale o pacote `pacote_operacao_distribuicao`.
4. Crie rotas em `/operations/routes`, romaneios em `/operations/manifests` e acompanhe entregas em `/operations/deliveries/monitoring`.
5. Registre POD em `/operations/deliveries/pod` e ocorrências em `/operations/deliveries/occurrences`.
6. Use os templates dinâmicos de avarias, devoluções, visita de promotor, checklist de PDV, reposição e satisfação pós-entrega pelo Studio.
7. Consulte KPIs operacionais nas views `integrarp.vw_operacoes_dashboard`, `integrarp.vw_entregas_dashboard`, `integrarp.vw_romaneio_dashboard`, `integrarp.vw_avarias_dashboard`, `integrarp.vw_devolucoes_dashboard` e `integrarp.vw_promotores_dashboard`.
8. Use as tools governadas da IA para status de entrega, rota, romaneio, avaria, devolução, visitas e templates operacionais.

### Windows, Docker e testes

- Windows: use `scripts/setup-windows.ps1`, `scripts/run-api-windows.ps1`, `scripts/run-web-windows.ps1`, `scripts/run-worker-windows.ps1` e `scripts/test-windows.ps1`.
- Docker: use `docker compose up --build`.
- Testes: execute `dotnet clean`, `dotnet restore`, `dotnet build` e `dotnet test` na raiz do repositório.

## Hardening e Governança — Sprint 11

### Como validar build e testes

Execute na raiz do repositório:

```bash
dotnet clean
dotnet restore
dotnet build
dotnet test
```

Se o app mobile existir, execute também:

```bash
cd apps/IntegraRP.Mobile
npm install
npm run typecheck
```

### Docker e Windows

Docker:

```bash
docker compose build
docker compose up -d
docker compose ps
```

Windows:

```cmd
scripts\build-windows.cmd
scripts\test-windows.cmd
scripts\run-api-windows.cmd
scripts\run-web-windows.cmd
scripts\run-worker-windows.cmd
```

### Health checks

- `GET /api/health` para status consolidado.
- `GET /api/health/live` para liveness.
- `GET /api/health/ready` para readiness.

### Logs e correlation_id

A API propaga `X-Correlation-Id` ou gera um novo identificador por requisição. Logs operacionais devem incluir `correlation_id`, `tenant_id`, `usuario_id`, operação e duração sem registrar senha, token, secrets ou dados sensíveis completos.

### Tenant isolation, auditoria, LGPD e IA governada

- Operações devem filtrar por `tenant_id` e aplicar RBAC.
- A auditoria registra ações críticas com usuário, tenant e correlation_id.
- O mascaramento central cobre CPF, CNPJ, telefone, e-mail, valores financeiros e campos dinâmicos sensíveis.
- A IA usa provider fake, executa somente tools registradas, valida permissões e cria fallback humano quando não puder responder com segurança.

### Performance básica

A migration `database/migrations/0011_hardening_indexes_observability.sql` adiciona índices idempotentes para auditoria, IA, Flow, Dynamic Records, pedidos, estoque, outbox e Project Kanban. Listagens grandes devem permanecer paginadas e evitar `SELECT *`.

### Checklist de piloto

O checklist operacional está em `docs/pilot-readiness-checklist.md` e deve ser revisado antes da Sprint 12 — Piloto v1.0.

## Pós-Piloto v1.1 — Form Builder, Automações, Anexos, Notificações e Relatórios

A v1.1 inaugura a evolução pós-piloto do IntegraRP com foco em configuração operacional avançada. O pacote inclui o script completo idempotente do banco em `database/scriptcompleto.sql`, os módulos de Form Builder avançado, regras de automação seguras, anexos versionados, notificações fake multicanal e relatórios exportáveis.

### Banco completo

Execute o script completo em PostgreSQL com um usuário autorizado:

```bash
psql "$DATABASE_URL" -f database/scriptcompleto.sql
```

O script usa exclusivamente o schema `integrarp`, cria `pgcrypto`, mantém `schema_migrations`, valida constraints/triggers/índices de forma idempotente e inclui seeds demo v1.1.
