# Padrões de desenvolvimento

- Uma classe por arquivo.
- SQL de runtime fica na Infrastructure; SQL versionado fica em `database/migrations`.
- Endpoints devem receber `CancellationToken`, logar contexto e delegar para Application.
- Novas tabelas devem usar schema `integrarp`, UUID, auditoria, soft delete e JSONB quando houver campos dinâmicos.
