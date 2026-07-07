# Auditoria v1.3 — In-memory, mocks e PostgreSQL

## Trocar agora por PostgreSQL
- `InMemoryFlowServices`, `InMemoryFlowCoreServices`: fluxos BPMN, instâncias, tarefas e auditoria devem usar tabelas `integrarp.*`, filtrar `tenant_id`, não usar `SELECT *` e registrar eventos operacionais.
- `InMemoryStudioServices`: módulos, campos, ações e registros dinâmicos devem usar Dapper/PostgreSQL.
- Billing/connect interno: faturas, títulos e outbox devem ser persistidos; o provider de boleto fake continua permitido apenas como sandbox.
- Jornada/onboarding: ações recomendadas, progresso e score devem ser persistidos; v1.3 adiciona `integrarp.v13_recommended_action` e views de validação.

## Manter fake/sandbox por enquanto
- SEFAZ/fiscal fake, WhatsApp, Telegram, e-mail e webhook fake: mantidos para sandbox quando não há credenciais reais.
- Boleto fake: mantido para demo e homologação sem integração bancária real.
- IA provider fake: permitido para governança e fallback humano, desde que use tools/use cases auditáveis.

## Trocar depois
- Mobile offline store em memória deve evoluir para cache local sincronizado por API real.
- Dados de demonstração estáticos em views Razor devem migrar gradualmente para endpoints reais com estado vazio inteligente.

## Remover
- Endpoints que retornem arrays fixos como fonte principal quando já houver endpoint real equivalente.
- Simulações internas que pulam tenant, RBAC, auditoria ou outbox.

## Objetos de controle v1.3
- `integrarp.v13_funcionalidade_status` mapeia componente, status, repository real e tela conectada.
- `integrarp.v13_demo_execucao` registra checkpoints do demo end-to-end.
- `integrarp.v13_recommended_action` persiste o widget “O que fazer agora”.
