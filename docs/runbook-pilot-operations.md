# Runbook operacional do piloto

## Subir ambiente
Docker: `docker compose -f docker-compose.yml -f docker-compose.pilot.yml up -d --build`.
Windows: usar scripts `run-pilot-api-windows.ps1`, `run-pilot-web-windows.ps1` e `run-pilot-worker-windows.ps1`.

## Derrubar ambiente
Docker: `docker compose -f docker-compose.yml -f docker-compose.pilot.yml down`.
Windows: encerrar processos ou parar Application Pools/serviço do Worker.

## Migrations
Aplicar migrations de forma controlada pela API com `IntegraRP__RunMigrations=true` ou por processo operacional aprovado.

## Logs
- API: console/container/IIS logs.
- Worker: console/container/serviço Windows.
- Web: console/container/IIS logs.

## PostgreSQL
Validar conexão, banco `integrarp`, usuário de aplicação e views `integrarp.vw_piloto_*`.

## Outbox
Consultar mensagens com erro, revisar payload, corrigir causa e reprocessar pelo Worker.

## Health checks
`/api/health/live`, `/api/health/ready` e Swagger.

## Operações comuns
Validar tenant, criar usuário, resetar senha demo, ver auditoria, revisar LGPD e registrar incidentes.

## Problemas comuns
API offline, banco indisponível, 401 por token expirado, 403 por RBAC, outbox com provider fake/log e erro de permissão em Windows.
