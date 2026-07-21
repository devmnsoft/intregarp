# Banco de dados IntegraRP v1.19

O arquivo canônico para instalação manual é `database/script_completop.sql`. O arquivo legado `database/scriptcompleto.sql` permanece temporariamente byte a byte igual, apenas para compatibilidade.

Fluxo standalone: crie o banco PostgreSQL 16, execute `script_completop.sql` duas vezes com `ON_ERROR_STOP=1` e execute `database/validate_script_completop.sql`.
