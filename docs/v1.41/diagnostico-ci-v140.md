# Diagnóstico do CI v1.40

## Escopo e rastreabilidade

- Workflow solicitado: run `30405186026`, associado ao commit
  `f6ed42935269845e0f5ce4da37bea3d983ddd40f`.
- Workflow recuperado do checkout: `IntegraRP CI v1.40 — Database Canonical`.
- Base disponível no ambiente: `0e6dd68c32cf013e8f37f6683773aa6f78f63889`.
- A consulta remota do run e o `git fetch` foram bloqueados pelo proxy com HTTP
  401/403. Por isso, as mensagens abaixo são as informadas no pedido e as
  evidências locais; detalhes não observados não são apresentados como sucesso.

## Falhas confirmadas

| Workflow | Job | Etapa | Mensagem / arquivo / linha | Causa raiz | Correção | Regressão | Evidência desta execução |
|---|---|---|---|---|---|---|---|
| IntegraRP CI v1.40 | `dotnet-windows` | build Release | `CS1011 Empty character literal`, `src/IntegraRP.Domain/Commercial/NextBestAction.cs` (validação do deep link) | Literal de caractere inválido na revisão executada pelo run. | O descendente local usa o literal válido `'/'`; a validação também passou a rejeitar nulo, vazio e whitespace antes de chamar `StartsWith`. | `V137ProductJourneyTests.NextBestActionRejectsExternalOrEmptyDeepLink`, incluindo whitespace. | Inspeção da fonte e `node --check`, `bash -n` e `py_compile` passaram. Build .NET não executado: SDK indisponível e instalação bloqueada por HTTP 403. |
| IntegraRP CI v1.40 | `dotnet-linux` | `dotnet format --verify-no-changes` | Diagnósticos de formatação, whitespace, usings e estilo, arquivos/linhas não recuperáveis sem o log remoto. | O gate combinava format, build e test; o primeiro erro interrompeu o job e ocultou as etapas seguintes. | A correção tocada nesta recuperação usa blocos explícitos e a formatação do repositório. Os demais diagnósticos exigem o log integral antes de correção responsável. | `dotnet format IntegraRP.sln --verify-no-changes --no-restore`. | Não executado: `dotnet` ausente. |
| IntegraRP CI v1.40 | `manifest-validation` | schema qualification | Centenas de ocorrências no relatório. | O checkout contém um relatório v1.40 com zero itens, incompatível com o resultado reportado pelo run; sem o artefato remoto não é possível classificar ocorrências sem fabricar evidência. | Nenhuma exclusão genérica foi adicionada. O artefato original deve ser recuperado e cada item classificado antes de alterar o linter. | `dotnet run --project tools/IntegraRP.DatabaseInspector -- lint-schema-qualification`. | Não executado: `dotnet` ausente. |
| IntegraRP CI v1.40 | `database-clean` | aplicar `scriptcompleto.sql` | `relation "integrarp.usuario" does not exist`. | O gerador v1.40 concatena migrations pela ordem do manifesto; essa ordem histórica não constitui uma ordenação topológica segura para instalação vazia. | Pendente do contrato canônico executável e de PostgreSQL 16 para validação real; não foi criado placeholder nem o erro foi suprimido. | Instalação em PostgreSQL 16 vazio seguida do validador. | Não executado: `psql`/PostgreSQL 16 indisponíveis. |
| IntegraRP CI v1.40 | `database-upgrade` | preparar/aplicar upgrade | `column "tenant_id" does not exist`. | O job prepara uma aproximação da versão anterior iterando arquivos por nome e consulta um contrato mais novo antes de assegurar que a coluna exista. | Pendente de snapshot v1.40 verificável. O job atual não deve ser tratado como prova de upgrade ou preservação. | Snapshot v1.40 + dados sentinela + runner + comparação de checksums. | Não executado: PostgreSQL e SDK indisponíveis. |
| IntegraRP CI v1.40 | jobs dependentes | release gate | Jobs cancelados ou não executados por dependência. | Dependências do workflow propagaram as falhas anteriores. Cancelamento não é sucesso. | Manter jobs de diagnóstico independentes e fazer o release gate depender de todos os gates obrigatórios. | Execução do workflow no SHA da branch. | Pendente de publicação e execução remota. |

## Estado do Portão Zero

O Portão Zero permanece **vermelho por limitação do ambiente**. O comando
`dotnet --info` retornou `dotnet: command not found`. A tentativa de instalar o
SDK 8.0 pelo repositório Ubuntu falhou porque o proxy retornou HTTP 403. Em
conformidade com a governança da release, nenhuma nova funcionalidade comercial,
migration histórica ou alteração de banco foi iniciada sem esse gate.

As verificações executáveis neste ambiente (`git diff --check`, sintaxe dos
scripts shell, compilação sintática dos scripts Python e `node --check` nos
JavaScripts próprios) concluíram com código zero.
