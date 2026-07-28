using Dapper;
using IntegraRP.Application.Commercial;
using IntegraRP.Infrastructure.Data;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public interface IOutboxBatchRepository
{
    Task<IReadOnlyList<OutboxEnvelope>> ClaimAsync(Guid tenantId, int batchSize, CancellationToken cancellationToken);
}

public sealed class PostgresOutboxBatchRepository(IDbConnectionFactory connectionFactory) : IOutboxBatchRepository
{
    public async Task<IReadOnlyList<OutboxEnvelope>> ClaimAsync(Guid tenantId, int batchSize, CancellationToken cancellationToken)
    {
        if (tenantId == Guid.Empty) throw new ArgumentException("Tenant obrigatório.", nameof(tenantId));
        using var connection = await connectionFactory.OpenConnectionAsync(cancellationToken);
        using var transaction = connection.BeginTransaction();
        var events = (await connection.QueryAsync<OutboxEnvelope>(new CommandDefinition("""
            with batch as (
              select id from integrarp.outbox_evento where tenant_id=@tenantId and status in ('pendente','erro')
               and coalesce(proxima_tentativa_em,now()) <= now() order by criado_em for update skip locked limit @batchSize
            )
            update integrarp.outbox_evento o set status='processando',atualizado_em=now()
              from batch where o.id=batch.id
            returning o.id Id,o.tenant_id TenantId,o.tipo Type,o.payload_json::text PayloadJson,o.correlation_id CorrelationId
            """, new { tenantId, batchSize = Math.Clamp(batchSize, 1, 500) }, transaction, cancellationToken: cancellationToken))).AsList();
        transaction.Commit();
        return events;
    }
}
