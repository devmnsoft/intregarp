using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Admin;

public sealed class PostgresProfileRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresProfileRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.perfil")
{
}
