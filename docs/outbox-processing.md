# Processamento Outbox

A tabela `integrarp.outbox_evento` guarda eventos pendentes, processados, com erro e cancelados. A tabela `integrarp.outbox_processamento_log` registra o histórico do processamento.

## Retry

Eventos com `status = erro` são elegíveis para reprocessamento automático quando `tentativas < max_tentativas`. Eventos cancelados ou acima do limite não são reprocessados automaticamente.

## Worker

O Worker executa ciclos periódicos, processa pendências, registra logs e continua em execução mesmo quando uma tentativa falha.
