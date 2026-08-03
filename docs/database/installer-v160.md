# IntegraRP v1.60 — instalador canônico one-shot

A instalação limpa é gerada exclusivamente das doze fases em `database/canonical/`; as migrations históricas não são concatenadas. `0060_v160_instalador_canonico_one_shot.sql` é reservada ao upgrade aditivo de bancos existentes.

## Instalação

Linux:

```bash
./scripts/install-integrarp-linux.sh --host localhost --port 5432 --database integrarp --username postgres --password 'senha-local' --install-mode Development --seed-demo
```

Windows:

```powershell
.\scripts\install-integrarp-windows.ps1 -Host localhost -Port 5432 -Database integrarp -Username postgres -Password 'senha-local' -InstallMode Development -SeedDemo
```

Os wrappers criam o banco apenas quando ausente e somente o removem quando o operador informa explicitamente `--reset-database`/`-ResetDatabase`. Em `Production`, as três variáveis `INTEGRARP_BOOTSTRAP_ADMIN_EMAIL`, `INTEGRARP_BOOTSTRAP_ADMIN_PASSWORD` e `INTEGRARP_BOOTSTRAP_ADMIN_NAME` são obrigatórias. Senhas não são escritas em log.

## Geração e prova

```bash
python3 scripts/generate-scriptcompleto.py
cmp database/scriptcompleto.sql database/script_completop.sql
psql -X "$POSTGRES_URI" --set ON_ERROR_STOP=1 --file database/scriptcompleto.sql
psql -X "$POSTGRES_URI" --set ON_ERROR_STOP=1 --file database/validate_scriptcompleto.sql
```

O script é PostgreSQL puro, mantém extensão/schema antes da transação, segura um advisory lock durante toda a instalação e executa DDL, seeds, ledger e validação na mesma transação. A reexecução preserva credenciais existentes porque o hash só é inserido quando ainda não há uma credencial ativa.

## Auditoria de conflito histórico

A fotografia canônica reconcilia as famílias repetidas `tenant`, `usuario`, `perfil`, `permissao`, `setor`, `cliente`, `produto`, `pedido`, `tarefa`, processos, `outbox_evento` e `titulo_financeiro`. Em especial, a fase 04 materializa as colunas de processo que eram ignoradas por `CREATE TABLE IF NOT EXISTS`. A migration 0060 repete somente ajustes aditivos para upgrade, sem `DROP TABLE`, `DROP CASCADE`, `TRUNCATE` ou exclusão de dados.
