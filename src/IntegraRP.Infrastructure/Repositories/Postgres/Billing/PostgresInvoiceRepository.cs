using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Billing;

public sealed class PostgresInvoiceRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresInvoiceRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.fatura")
{
}
