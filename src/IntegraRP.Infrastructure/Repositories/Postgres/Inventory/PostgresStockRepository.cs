using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Inventory;

public sealed class PostgresStockRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresStockRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.estoque_saldo")
{
}
