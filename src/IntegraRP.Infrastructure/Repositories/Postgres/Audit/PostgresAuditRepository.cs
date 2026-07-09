using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Audit;

public sealed class PostgresAuditRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresAuditRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.auditoria_evento")
{
    public Task<IReadOnlyList<Guid>> ListIdsAsync(Guid tenantId, int page, int pageSize, string? status, CancellationToken cancellationToken)
        => base.ListIdsAsync(tenantId, page, pageSize, status, cancellationToken);

    public Task<bool> SoftDeleteAsync(Guid tenantId, Guid id, Guid? userId, CancellationToken cancellationToken)
        => base.SoftDeleteAsync(tenantId, id, userId, cancellationToken);
}
