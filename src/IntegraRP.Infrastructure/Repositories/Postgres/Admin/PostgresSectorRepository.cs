using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Admin;

public sealed class PostgresSectorRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresSectorRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.setor")
{
}
