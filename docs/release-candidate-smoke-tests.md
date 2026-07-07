# release-candidate-smoke-tests

Documento v1.6 de validação Release Candidate.

## Status
Parcial: criado para orientar execução real sem afirmar validação não executada.

## Como validar
- Banco: `pwsh scripts/db-apply-scriptcompleto.ps1`.
- Docker: `pwsh scripts/validate-docker-release.ps1`.
- API: `pwsh scripts/smoke-test-api.ps1`.
- Web: `pwsh scripts/smoke-test-web.ps1`.
- Worker: `pwsh scripts/smoke-test-worker.ps1`.

## Observações
Usar somente schema `integrarp`, não commitar secrets e registrar evidências no PR.
