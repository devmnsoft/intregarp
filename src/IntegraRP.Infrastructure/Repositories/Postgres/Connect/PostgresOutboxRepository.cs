using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Connect;

public sealed class PostgresOutboxRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresOutboxRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.outbox_evento")
{
}
