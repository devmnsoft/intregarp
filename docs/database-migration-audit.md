# Auditoria de migrations

## Resultado
As migrations seguem o padrão `NNNN_descricao.sql` e usam o schema `integrarp`. Há duplicidade histórica no número `0014`:
- `0014_v12_integracoes_fiscal_conciliacao_rotas_offline.sql`
- `0014_v12_jornada_cliente_onboarding_ux.sql`

## Estratégia segura
Não remover migrations já versionadas, pois podem ter sido aplicadas em ambientes existentes. A ordem segura está registrada em `database/migration_manifest.json`; novas correções devem ser criadas com versão posterior, como `0018_v16_release_candidate_validation.sql`.

## Validações automatizadas
- `scripts/db-validate-migrations.ps1` valida padrão, schema proibido e presença de `integrarp`.
- `V16ReleaseCandidateTests` valida manifest, script completo e assets v1.6.
