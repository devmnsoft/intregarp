using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Inventory;

public sealed class PostgresProductRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresProductRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.produto")
{
}
