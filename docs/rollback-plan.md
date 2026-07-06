# Plano de rollback

1. Comunicar indisponibilidade e congelar novas operações.
2. Parar Web, API e Worker.
3. Preservar logs e exportar evidências do incidente.
4. Restaurar pastas/containers da versão anterior.
5. Restaurar banco a partir do backup se a migration ou dados forem afetados.
6. Reaplicar variáveis da versão anterior.
7. Subir PostgreSQL, API, Worker e Web.
8. Validar health, Swagger, login, tenant, pedido e auditoria.
9. Comunicar normalização aos usuários.
10. Registrar causa, impacto, decisão e próximos passos.
