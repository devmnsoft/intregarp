# Checklist de IA Governada

- [ ] IA usa provider fake nesta sprint.
- [ ] IA só executa tools registradas.
- [ ] IA valida tenant, RBAC, escopo e permissão da tool.
- [ ] IA não executa SQL dinâmico, não usa eval e não acessa banco diretamente.
- [ ] Baixa confiança, tool inexistente ou falta de permissão gera fallback humano.
- [ ] Toda pergunta gera auditoria em `ai_auditoria`.
