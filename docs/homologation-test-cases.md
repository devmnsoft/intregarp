# Casos de teste de homologação

| ID | Área | Caso | Resultado esperado |
| --- | --- | --- | --- |
| H01 | Login | Autenticar e selecionar tenant | Dashboard inicial carregado. |
| H02 | Permissões | Acessar tela sem permissão | Resposta 403 amigável e auditável. |
| H03 | Flow | Publicar processo e concluir tarefa | Instância avança e auditoria é registrada. |
| H04 | Studio | Publicar Controle de Avarias | Registro dinâmico criado e consultável. |
| H05 | Pedido | Criar e confirmar pedido | Estoque reservado e Flow iniciado. |
| H06 | Estoque | Registrar entrada e lote | Saldo disponível atualizado. |
| H07 | Faturamento | Gerar fatura, título e boleto fake | Artefatos fake/log registrados. |
| H08 | Connect | Processar outbox | Histórico mostra pendente e processado. |
| H09 | BI | Visualizar KPIs | Dashboard e score operacional carregam. |
| H10 | Project | Criar sprint/card e mover card | Feed atualizado e export/import disponível. |
| H11 | Mobile | Abrir tarefa e concluir checklist | Evidência, GPS e assinatura registrados. |
| H12 | Operações | Criar rota, romaneio, POD e ocorrência | Monitoramento exibe status atualizado. |
| H13 | IA | Perguntar com e sem permissão | Resposta autorizada ou fallback humano auditado. |
| H14 | LGPD | Visualizar dado sensível | Máscara aplicada e acesso auditado. |
| H15 | Worker | Reprocessar outbox com erro | Worker registra logs claros sem derrubar. |
