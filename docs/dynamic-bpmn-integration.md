# dynamic bpmn integration

Este documento descreve a Sprint 9 do IntegraRP Studio Avançado.

## Visão geral

O Studio permite criar módulos dinâmicos por metadados no schema obrigatório `integrarp`, sem criar uma migration por módulo de usuário. A estrutura cobre módulos, entidades, campos, ações, relacionamentos, BPMN, KPIs, catálogo semântico, registros, histórico, comentários, anexos e auditoria.

## Segurança

- Todas as consultas operacionais devem filtrar `tenant_id`.
- Campos sensíveis LGPD exigem mascaramento.
- Ações críticas devem registrar histórico/auditoria.
- Metadados não executam SQL arbitrário nem código dinâmico.

## Uso

1. Acesse `/studio`.
2. Crie ou sugira um módulo.
3. Configure campos, ações, BPMN, KPIs e IA/Semântico no builder.
4. Publique o módulo.
5. Acesse registros em `/dynamic/{moduleCode}`.
