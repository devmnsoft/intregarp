# IntegraRP v1.42 — diagnóstico inicial

## Base e governança

- Base local confirmada: `79bf1722bc13f53f6804a4b7277ad7f3db0f9d12`.
- Branch de trabalho: `codex/v142-recovery-tecnica-banco-ci-verde`.
- O commit exigido é o próprio `HEAD` da base local.
- O ambiente não forneceu remoto Git nem credenciais de GitHub, e a conexão HTTPS foi recusada (HTTP 403). Por isso, os logs do run `30455314705` não ficaram acessíveis nesta execução. Nenhum resultado desse run é presumido.
- O ambiente também não contém SDK .NET nem cliente/servidor PostgreSQL. Os gates dependentes dessas ferramentas permanecem **não homologados**, até uma execução real no GitHub Actions.

## Falhas confirmadas por inspeção

1. `NextBestAction` usava a sobrecarga inexistente `StartsWith(char, StringComparison)`, impedindo compilação.
2. O proxy passava um method group com contrato de nulabilidade incompatível para encaminhar cabeçalhos, origem do CS8620.
3. Dois controllers publicavam `POST api/notifications/{id:guid}/read`; o controller histórico agora tem namespace de rota legado inequívoco.
4. O dashboard ainda referenciava `window.IntegraFeedback`, divergindo do centro global `window.IntegraRPFeedback`.
5. O nome do workflow ainda identificava a v1.40.

## Correções e regressão

- A validação de deep links agora usa a sobrecarga de `string` e possui casos positivos e negativos explícitos.
- O encaminhamento copia somente valores não nulos para `HttpHeaders`, sem cast, supressão ou `NoWarn`.
- A API atual preserva `api/notifications`; a API histórica foi isolada em `api/legacy/notifications`.
- O dashboard usa o centro global oficial.
- O workflow foi identificado como v1.42.

## Limite da homologação

Este documento não declara build, PostgreSQL ou release gate verdes. Esses resultados somente podem ser preenchidos após execução real no SHA da branch.
