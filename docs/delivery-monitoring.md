# delivery monitoring

Documento da Sprint 10 para o pacote operacional de distribuição e campo do IntegraRP.

## Escopo

- Templates operacionais instaláveis pelo Studio.
- Rotas, paradas, romaneios, POD, ocorrências e monitoramento.
- KPIs, catálogo semântico de IA, auditoria e worker operacional.
- Uso exclusivo do schema integrarp e instalação idempotente, sem SQL dinâmico salvo em metadados.

## Como testar

1. Aplicar a migration database/migrations/0010_templates_operacionais_distribuicao_campo.sql.
2. Abrir o Web em /operational/templates.
3. Instalar o Pacote Operação Distribuição.
4. Criar rota, romaneio, POD e ocorrência pelos endpoints /api/operations ou pelas telas Web.
5. Consultar dashboards e tools governadas da IA.
