# Revisão de Performance

A migration `0011_hardening_indexes_observability.sql` adiciona índices idempotentes para tenant, status, datas, responsáveis, pedidos, clientes, produtos, outbox, auditoria, IA e Project Kanban.

## Regras

- Listagens grandes devem ter paginação.
- Evitar `SELECT *`.
- Dynamic Records filtra por tenant e módulo.
- Project Kanban carrega por board e tenant.
