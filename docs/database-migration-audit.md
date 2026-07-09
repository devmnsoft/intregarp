# Auditoria de migrations — v1.6

## Achados
- Migrations em `database/migrations` seguem padrão `NNNN_descricao.sql`.
- A numeração `0014` possui duas migrations históricas: integrações/fiscal/conciliação/rotas/offline e jornada/onboarding/UX.
- Estratégia segura: manter ambas, registrar no `database/migration_manifest.json` e aplicar por ordenação lexicográfica estável.
- Nenhuma migration deve referenciar schemas proibidos com qualificador `public.` ou `integra.`.
- Toda nova migration deve usar `integrarp.` e ser idempotente.

## V1.6
- Criada `0018_v16_release_candidate_validation.sql` com tabela, constraints, índices, trigger, view e seed de checks RC.
- O script completo recebeu o mesmo bloco para manter a fonte única consolidada.

## Validação automatizada
- `V16ReleaseCandidateTests` valida padrão de nomes, duplicidade histórica conhecida, schema permitido, manifesto e objetos v1.6.
- Workflow `database-validation` aplica `scriptcompleto.sql` duas vezes em PostgreSQL limpo.
