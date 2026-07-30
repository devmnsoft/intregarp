using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresCustomerContactRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresCustomerContactRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.cliente_contato")
{
}
