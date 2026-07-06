# advanced-attachments

Documento da fase Pós-Piloto v1.1 do IntegraRP.

## Escopo

- Form Builder avançado com seções, versionamento, publicação, preview e respostas vinculadas a entidades operacionais.
- Automações configuráveis sem eval, sem SQL dinâmico e com logs/auditoria por tenant.
- Anexos avançados com metadados, storage_key, SHA-256, versionamento e auditoria de acesso.
- Notificações sistema, email_fake, whatsapp_fake, telegram_fake, mobile_push_fake e webhook_fake.
- Relatórios exportáveis em csv, pdf_html, json e xlsx quando houver biblioteca viável.
- Banco idempotente centralizado em `database/scriptcompleto.sql` usando somente o schema `integrarp`.

## Segurança e operação

Todos os fluxos devem validar tenant_id, RBAC e permissões do usuário antes de executar ações críticas. Falhas devem ser registradas em logs estruturados e, quando aplicável, em tabelas de auditoria.

## Como testar

1. Executar `dotnet clean`, `dotnet restore`, `dotnet build` e `dotnet test`.
2. Executar o script `database/scriptcompleto.sql` em uma base PostgreSQL limpa ou existente.
3. Validar seeds demo de formulários, automações, relatórios, notificações e anexos.
