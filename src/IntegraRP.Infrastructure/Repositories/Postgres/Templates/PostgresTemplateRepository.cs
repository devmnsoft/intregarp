using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Templates;

public sealed class PostgresTemplateRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresTemplateRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.template_operacional")
{
}
