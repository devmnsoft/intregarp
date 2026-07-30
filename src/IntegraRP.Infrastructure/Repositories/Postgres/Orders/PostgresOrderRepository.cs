using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Orders;

public sealed class PostgresOrderRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresOrderRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.pedido")
{
}
