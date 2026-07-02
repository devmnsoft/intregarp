# Integra Flow Designer Web

O Designer fica em `/flow/designer`, com catálogo em `/flow/designer/templates` e editor em `/flow/designer/versions/{versionId}`. Use um template para clonar um processo ou adicione elementos de início, tarefa humana, atividade automática, gateway, subprocesso e fim no editor visual.

## Operação

1. Clone um template operacional.
2. Configure responsável, SLA, formulário e checklist em cada etapa.
3. Crie transições com condição `always`, regras por variável ou fallback.
4. Execute a validação antes de publicar.
5. Publique somente quando não houver erros críticos; warnings podem ser confirmados.

## Windows e Docker

No Windows, use `scripts\run-all-windows.ps1`. Com Docker, use `docker compose up --build`.
