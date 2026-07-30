using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresCustomerAddressRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresCustomerAddressRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.cliente_endereco")
{
}
