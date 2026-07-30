# IntegraRP v1.44 — diagnóstico inicial

## Governança

- SHA base local: `be99a76e804f1cae9235dd6533b6d85ce9a8bd70`.
- Workflow solicitado: execução `30483988618`.
- Consulta remota em 2026-07-30: bloqueada antes da autenticação (`CONNECT tunnel failed, response 403`; a ferramenta GitHub CLI não está instalada). Portanto, nenhum resultado remoto é presumido neste documento.
- Ferramentas locais: `dotnet`, `psql` e `docker` indisponíveis.

## Primeiras causas confirmadas no código-base

| Job/etapa | Mensagem original informada | Arquivo/linha na base | Causa raiz | Correção | Regressão executada | Estado | Execução comprobatória |
|---|---|---|---|---|---|---|---|
| dotnet-linux / compile Infrastructure | `IHostEnvironment` não encontrado | `src/IntegraRP.Infrastructure/Auth/DevelopmentPasswordResetSender.cs:7` | Infrastructure usava Hosting sem referenciar seu pacote de abstrações | Referenciar somente `Microsoft.Extensions.Hosting.Abstractions` | validação estática do projeto; build indisponível | aguardando CI | não disponível |
| dotnet-linux / compile Infrastructure | `AuthSessionDto` não resolvido | `src/IntegraRP.Infrastructure/Auth/PostgresAuthenticationRepository.cs:26` | ausência do `using IntegraRP.Contracts.Auth` | importar o contrato canônico já existente | confirmação de definição única via `rg` | corrigido estaticamente | local |
| warnings-as-errors / CS0108 | membros `ListIdsAsync` e `SoftDeleteAsync` ocultados | repositories PostgreSQL derivados | base expunha operações como `protected`, forçando wrappers públicos homônimos | tornar operações públicas na base e herdar a implementação; remover 20 pares redundantes | busca por wrappers duplicados retornou zero | corrigido estaticamente | local |

## Validações locais reais

Passaram: sintaxe Bash, compilação Python, sintaxe dos JavaScripts próprios, geração determinística do SQL, igualdade dos aliases SQL e validação sintática dos contratos JSON. Build, PostgreSQL, runtime e testes .NET permanecem sem evidência neste ambiente.
