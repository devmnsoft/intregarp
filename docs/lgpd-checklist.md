# Checklist LGPD

- [ ] CPF, CNPJ, telefone, e-mail e valores sensíveis são mascarados sem permissão.
- [ ] Campos dinâmicos com `sensivel_lgpd = true` são mascarados.
- [ ] Acesso a dado sensível registra tenant, usuário, recurso, campo, motivo e correlation_id.
- [ ] IA não retorna dado sensível completo sem permissão.
- [ ] Solicitações do titular e consentimentos possuem trilha de auditoria.
