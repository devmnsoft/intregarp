using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Audit;

public sealed class PostgresAuditRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresAuditRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.auditoria_evento")
{
}
