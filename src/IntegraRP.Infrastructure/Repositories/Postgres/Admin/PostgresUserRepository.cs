using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Admin;

public sealed class PostgresUserRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresUserRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.usuario")
{
}
