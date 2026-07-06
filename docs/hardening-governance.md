# Hardening e Governança

A Sprint 11 consolida build, tenant isolation, RBAC, auditoria, LGPD, IA governada, observabilidade, performance e prontidão operacional.

## Validação obrigatória

1. `dotnet clean`
2. `dotnet restore`
3. `dotnet build`
4. `dotnet test`
5. Mobile: `npm install` e `npm run typecheck` em `apps/IntegraRP.Mobile`.

## Guardrails

- Objetos de banco usam somente o schema `integrarp`.
- Controllers não devem acessar Dapper ou SQL inline.
- Web e Mobile consomem API, sem acesso direto ao banco.
- Domain não referencia Infrastructure, Api, Web, Dapper, Npgsql ou ASP.NET.
