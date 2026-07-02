# Fluxo pedido → faturamento → notificação

1. Pedido confirmado inicia o Flow “Pedido ao Pós-venda”.
2. A etapa de faturamento abre `/orders/{id}/billing`.
3. O usuário gera fatura a partir do pedido.
4. A fatura emitida gera título financeiro.
5. O título gera boleto fake/log.
6. Uma referência fiscal fake/log é registrada.
7. O sistema enfileira mensagens para cliente e responsáveis internos.
8. O Worker processa outbox.
9. Dashboards financeiro e Connect refletem o resultado.
