# Plano de go-live

## Pré-go-live
Validar build, testes, Docker, Windows, migrations, credenciais demo, usuários, dados e backups.

## Backup
Realizar backup lógico do PostgreSQL, preservar artefatos publicados e exportar logs relevantes.

## Deploy
Aplicar pacote versionado, configurar variáveis, executar migrations controladas, iniciar API, Web e Worker.

## Smoke test
Health live/ready, Swagger, Web, login, tenant, pedido, faturamento fake/log, outbox, dashboard e auditoria.

## Responsáveis
Definir responsável técnico, negócio, suporte, comunicação e aprovador do aceite.

## Comunicação
Informar janela, impactos, canais de suporte, critérios de sucesso e plano de rollback.

## Critérios de sucesso
Serviços disponíveis, usuários validados, fluxos críticos concluídos e monitoramento sem erros críticos nas primeiras 48 horas.

## Rollback
Acionar se houver perda de dados, indisponibilidade prolongada, falha de login/RBAC ou erro crítico sem contorno.

## Suporte assistido
Plantão nas primeiras 48 horas, triagem por severidade, registro de incidentes e atualização diária do status.

## Checklist pós-go-live
Validar logs, outbox, auditoria, LGPD, backups, usuários ativos e pendências da homologação.
