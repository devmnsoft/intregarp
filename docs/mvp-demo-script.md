# Roteiro de demonstração do MVP

1. Faça login no sistema.
2. Abra o dashboard principal.
3. Crie ou abra o cliente demo.
4. Crie ou abra o produto demo.
5. Crie um pedido.
6. Confirme o pedido.
7. Verifique o processo Flow “Pedido ao Pós-venda” iniciado.
8. Abra a etapa de faturamento em `/orders/{id}/billing`.
9. Clique em **Gerar fatura**.
10. Clique em **Gerar título**.
11. Clique em **Gerar boleto fake** e destaque a linha digitável `FAKE-BOLETO`.
12. Crie uma referência de NF fake/log em `/billing/fiscal-documents`.
13. Clique em **Enviar mensagem fake/log** para enfileirar notificação.
14. Abra `/connect/outbox` e processe o evento pendente.
15. Abra `/billing` e confira fatura emitida, título aberto e valores.
16. Abra `/connect` e confira mensagens e outbox.
17. Abra histórico/auditoria pelos logs da API e Worker.
