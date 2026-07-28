# Script completo canônico — IntegraRP v1.40

O arquivo oficial é `database/scriptcompleto.sql`; `database/script_completop.sql` é somente um alias temporário, gerado byte a byte pela mesma fonte. PostgreSQL **16** é obrigatório.

```bash
psql -X "$POSTGRES_URI" \
  --set ON_ERROR_STOP=1 \
  --file database/scriptcompleto.sql
```

O script valida a versão, cria `pgcrypto` e o schema `integrarp`, obtém um advisory lock de sessão e executa todas as migrations dentro de uma transação. Qualquer erro interrompe o `psql` e causa rollback; não há `search_path`. Reexecuções são suportadas por DDL idempotente e validação final.

Gere os dois aliases e o inventário com `python3 scripts/generate-scriptcompleto.py`. O gerador valida ordem, arquivos extras/ausentes, SHA-256 de cada migration, UTF-8 sem BOM e LF. Para validar uma instalação, execute `database/validate_scriptcompleto.sql`.

## Erros e rollback

Dados incompatíveis, órfãos ou constraints inválidas devem ser corrigidos explicitamente antes de repetir. Não se deve truncar, apagar dados nem usar `DROP CASCADE`. Se a conexão cair depois de adquirir o lock, o PostgreSQL libera o lock de sessão automaticamente.
