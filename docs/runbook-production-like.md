# Runbook Production-like

## Subida

1. Aplicar migrations no schema `integrarp`.
2. Subir PostgreSQL, API, Web e Worker.
3. Validar `/api/health`, `/api/health/live` e `/api/health/ready`.

## Incidentes

- Coletar `correlation_id`.
- Verificar logs de API e Worker.
- Conferir outbox pendente e tentativas máximas.
- Validar tenant e permissões do usuário afetado.

## Backup/restore

Executar backup lógico do banco antes de migrations e validar restore em ambiente isolado.
