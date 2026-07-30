using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Inventory;

public sealed class PostgresStockMovementRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresStockMovementRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.estoque_movimento")
{
}
