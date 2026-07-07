# Demo v1.3 — Fluxo ponta a ponta real

1. Executar `/database/scriptcompleto.sql` em PostgreSQL com schema `integrarp`.
2. Validar `integrarp.vw_v13_demo_health`.
3. Login como admin demo.
4. Abrir onboarding e confirmar tenant demo.
5. Criar ou reutilizar cliente demo.
6. Criar produto demo.
7. Registrar entrada de estoque.
8. Criar e confirmar pedido.
9. Confirmar criação de instância Flow e tarefa.
10. Abrir “O que fazer agora” e concluir tarefa.
11. Gerar fatura, título e boleto fake.
12. Confirmar mensagem no outbox e processar worker.
13. Abrir dashboard/BI/project e validar KPIs/cards.
14. Perguntar à IA “o que fazer agora?” e validar auditoria.

## Views de validação
- `integrarp.vw_v13_fluxo_pedido_end_to_end`
- `integrarp.vw_v13_o_que_fazer_agora_real`
- `integrarp.vw_v13_demo_health`

## API de validação
- `GET /api/validation/health/end-to-end`
- `GET /api/validation/demo/status`
- `GET /api/validation/scriptcompleto/status`
