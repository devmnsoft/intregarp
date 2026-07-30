# Decisões arquiteturais v1.44

## ADR-144-001 — abstração de Hosting na Infrastructure

**Decisão:** adicionar `Microsoft.Extensions.Hosting.Abstractions` à Infrastructure. O sender precisa distinguir Development sem depender do host concreto; o pacote contém somente os contratos oficiais usados (`IHostEnvironment` e extensões), já consumidos pelo composition root. Isso evita criar uma abstração duplicada sem eliminar a dependência conceitual.

## ADR-144-002 — operações CRUD herdadas

**Decisão:** `DomainCrudRepository` expõe publicamente `ListIdsAsync` e `SoftDeleteAsync`. Repositories derivados herdam essas implementações quando não têm comportamento adicional. Os wrappers homônimos foram removidos em vez de ocultados com `new`; uma futura especialização deverá usar composição ou um contrato explicitamente virtual quando houver comportamento distinto.

## ADR-144-003 — contrato único de sessão

**Decisão:** `AuthSessionDto` permanece definido exclusivamente em `IntegraRP.Contracts.Auth`. Infrastructure importa esse namespace e implementa exatamente o contrato da Application, sem DTO paralelo.
