using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Billing;

public sealed class PostgresFinancialTitleRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresFinancialTitleRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.titulo_financeiro")
{
}
