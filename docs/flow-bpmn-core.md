# Integra Flow - flow-bpmn-core

Documento da Sprint 3 do Integra Flow BPMN Core Engine.

- Schema obrigatório: integrarp.
- Migration: database/migrations/0003_flow_bpmn_core.sql.
- Seed: Pedido ao Pós-venda ().
- Runtime: inicia instâncias, cria tarefas humanas, avalia gateways simples, registra auditoria e publica eventos/outbox fake/log.
- Testes esperados: arquitetura, SQL, domínio, motor, tenant, auditoria e eventos.
