# Upgrade para IntegraRP v1.40

1. Faça backup verificável e suspenda escritores.
2. Confirme PostgreSQL 16 e aplique `database/scriptcompleto.sql` com `ON_ERROR_STOP=1`.
3. Execute `database/validate_scriptcompleto.sql`.
4. Execute o Migration Runner duas vezes; a segunda execução deve aplicar zero migrations.
5. Compare contagens, IDs, valores e relacionamentos com o registro anterior.

O script é aditivo e transacional. Ele não remove tabelas ou dados. Divergências reais abortam a instalação e exigem correção manual orientada; o rollback é o rollback da transação e, para desastre, a restauração do backup. Migrations 0001–0045 permanecem congeladas; a alteração v1.40 está em 0046.
