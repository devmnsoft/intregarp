# Status de repositories v1.3

## Implementação real obrigatória
- Core: tenant, user, profile, permission, sector, audit.
- Journey: customer journey, progress, recommended action, contextual help.
- Flow: definition, version, element, transition, instance, task, audit.
- Studio: module, field, action, record, record history.
- Commercial/inventory/orders: customer, product, stock, reservation, order.
- Billing/connect: invoice, title, outbox, dispatch.
- BI/project: KPI, dashboard, board, item, feed.
- Forms/automation/reports: forms, responses, rules, executions, reports, notifications, attachments.

## Regras de aceite
Toda consulta operacional filtra `tenant_id`, não usa `SELECT *`, usa parâmetros Dapper, paginação e transação quando necessário.
