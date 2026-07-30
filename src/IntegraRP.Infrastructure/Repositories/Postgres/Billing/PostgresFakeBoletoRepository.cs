using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Billing;

public sealed class PostgresFakeBoletoRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresFakeBoletoRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.boleto_fake")
{
}
