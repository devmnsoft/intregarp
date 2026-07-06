# Validação Docker e Windows

## Docker

1. `docker compose build`
2. `docker compose up -d`
3. `docker compose ps`
4. Validar API, Web, Worker, PostgreSQL, migrations e health checks.

## Windows

Executar os scripts CMD sem comandos Linux-only:

- `scripts\build-windows.cmd`
- `scripts\test-windows.cmd`
- `scripts\run-api-windows.cmd`
- `scripts\run-web-windows.cmd`
- `scripts\run-worker-windows.cmd`
