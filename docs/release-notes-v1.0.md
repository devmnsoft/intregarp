# Release notes v1.0 — Piloto

## Visão
A versão v1.0 piloto estabiliza o IntegraRP para uso assistido com API, Web, Worker, Mobile, Docker, Windows, health checks, auditoria, LGPD e dados demonstrativos.

## Funcionalidades entregues
Login, tenant, RBAC, dashboard, Flow/BPMN, Studio, registros dinâmicos, comercial, estoque, pedidos, faturamento fake/log, Connect/outbox, BI, Project, Mobile/campo, operações de distribuição e IA governada.

## Limitações conhecidas
- WhatsApp real ainda não implementado.
- IA externa real ainda não implementada.
- NF-e real ainda não implementada.
- Integrações bancárias reais ainda não implementadas.
- Mapas/roteirização real ainda não implementados.
- Algumas funcionalidades são MVP/fake/log para validação operacional.

## O que é fake/log
Provedores fake/log registram intenção, payload, histórico e auditoria sem chamar serviços externos reais.

## Requisitos
.NET 8, PostgreSQL 16, Node 20 para Mobile, Docker Desktop ou Windows Server/IIS com Hosting Bundle.

## Atualização
Aplicar migrations até `0012_piloto_v1_final_adjustments.sql`, publicar serviços, validar health checks e executar smoke tests.

## Rollback
Seguir `docs/rollback-plan.md`: parar serviços, restaurar versão anterior, restaurar backup se necessário e validar health.

## Próximos passos
Correções reais de homologação, WhatsApp/e-mail real, NF-e real, banco/boletos reais, mapas/roteirização real e melhorias comerciais.
