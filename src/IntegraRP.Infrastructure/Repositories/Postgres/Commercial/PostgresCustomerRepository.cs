using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresCustomerRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresCustomerRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.cliente")
{
}
