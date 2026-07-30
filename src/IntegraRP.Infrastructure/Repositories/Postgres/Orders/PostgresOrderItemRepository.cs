using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Orders;

public sealed class PostgresOrderItemRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresOrderItemRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.pedido_item")
{
}
