# Arquitetura IntegraRP

Clean Architecture com dependências apontando para dentro: API/Web/Worker orquestram casos de uso; Application define contratos; Domain mantém invariantes puras; Infrastructure implementa Dapper, Npgsql, migrations, outbox e integrações fake.
