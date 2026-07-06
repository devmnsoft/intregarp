# Checklist de Segurança

- [ ] Endpoints protegidos usam autenticação e autorização.
- [ ] Tenant resolvido antes de operações protegidas.
- [ ] Usuário sem tenant recebe 403.
- [ ] Usuário sem permissão recebe 403.
- [ ] Refresh token armazenado somente como hash.
- [ ] Senhas, tokens e secrets não aparecem em logs.
- [ ] Auditoria registra login, logout, refresh token, usuários, permissões e alterações críticas.
