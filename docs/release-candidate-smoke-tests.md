# release-candidate-smoke-tests

## Status v1.6
Documento criado para a Release Candidate. Status atual: **Parcial**, com validação local limitada pelo ambiente Codex sem SDK .NET e sem Docker.

## Como validar
- Build/test: executar `dotnet clean`, `dotnet restore`, `dotnet build`, `dotnet test` ou aguardar GitHub Actions.
- Banco: executar `scripts/db-validate-scriptcompleto.ps1` contra PostgreSQL limpo.
- Docker: executar `scripts/validate-docker-release.ps1` em host com Docker.
- Smoke: executar `scripts/smoke-test-api.ps1`, `scripts/smoke-test-web.ps1`, `scripts/smoke-test-worker.ps1` e `scripts/smoke-test-customer-journey.ps1`.

## Limitações conhecidas
- Evidência de build .NET e Docker deve vir do CI/host local com ferramentas instaladas.
- Providers fiscal/boleto externos permanecem fake/sandbox documentados.
- Endpoints de validação v1.6 expõem contrato e devem evoluir para consulta direta em views PostgreSQL.
