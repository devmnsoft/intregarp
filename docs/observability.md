# Observabilidade

## Correlation ID

A API aceita `X-Correlation-Id` ou gera um identificador e o devolve na resposta. Logs devem incluir `correlation_id`, `tenant_id`, `usuario_id`, operação e tempo de execução quando aplicável.

## Health checks

- `GET /api/health` — visão consolidada.
- `GET /api/health/live` — processo vivo.
- `GET /api/health/ready` — dependências prontas.

## Logs seguros

Não registrar senha, token, secrets ou dados pessoais completos.
