# Integra Financeiro/Faturamento

O módulo de faturamento cria faturas simplificadas, itens, títulos financeiros, boletos fake/log, referências fiscais fake/log e documentos de faturamento. A migration `0006_faturamento_connect_outbox.sql` cria tabelas idempotentes no schema `integrarp`.

## Fluxo principal

1. Criar fatura manualmente ou a partir de pedido.
2. Adicionar itens enquanto a fatura estiver em rascunho.
3. Emitir fatura.
4. Criar título financeiro a partir da fatura.
5. Gerar boleto fake/log.
6. Criar referência fiscal fake/log.
7. Registrar auditoria via logs estruturados.

## Endpoints

- `GET /api/billing/invoices`
- `POST /api/billing/invoices`
- `POST /api/billing/invoices/from-order/{orderId}`
- `POST /api/billing/invoices/{id}/items`
- `POST /api/billing/invoices/{id}/issue`
- `GET /api/billing/titles`
- `POST /api/billing/titles/from-invoice/{invoiceId}`
- `POST /api/billing/titles/{id}/generate-boleto`
- `GET /api/billing/dashboard`
