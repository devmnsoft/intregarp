# Auditoria Web — telas com API real

| Rota | Status v1.7 | Endpoint esperado | Loading | 401/403 | Vazio | Próxima ação |
|---|---|---|---|---|---|---|
| /login | Parcial | /api/auth/login | Parcial | Parcial | OK | Entrar com demo |
| /dashboard | Parcial | /api/dashboard | Pendente | Pendente | Pendente | Ver KPIs |
| /getting-started | Parcial | /api/journey | Pendente | Pendente | OK | Completar onboarding |
| /journey/what-to-do-now | Parcial | /api/journey/recommended-actions | Pendente | Pendente | OK | Executar ação recomendada |
| /customers | Risco | /api/customers | Pendente | Pendente | Pendente | Criar cliente |
| /products | Risco | /api/products | Pendente | Pendente | Pendente | Criar produto |
| /inventory | Risco | /api/inventory | Pendente | Pendente | Pendente | Registrar estoque |
| /orders | Risco | /api/orders | Pendente | Pendente | Pendente | Criar pedido |
| /flow/tasks | Parcial | /api/flow/tasks | Pendente | Pendente | Pendente | Assumir tarefa |
| /billing | Parcial | /api/billing | Pendente | Pendente | Pendente | Gerar fatura |
| /connect/outbox | Parcial | /api/connect/outbox | Pendente | Pendente | Pendente | Processar outbox |
| /project | Parcial | /api/project | Pendente | Pendente | Pendente | Atualizar board |

Critério RC: dados fixos só podem existir como fallback/estado vazio, nunca como fonte principal quando a API estiver disponível.

## Critérios v1.7 por tela

Cada tela deve manter endpoint real, loading, erro, tratamento 401, tratamento 403, estado vazio inteligente, próxima ação recomendada e ajuda contextual. Quando uma tela ainda depender de dados estáticos, marcar como `warning` e substituir por chamada API no próximo incremento.
