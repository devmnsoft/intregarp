using Dapper;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Repositories.Postgres;

public abstract class DomainCrudRepository(PostgresConnectionFactory connectionFactory, ILogger logger, string tableName)
{
    protected async Task<IReadOnlyList<Guid>> ListIdsAsync(Guid tenantId, int page, int pageSize, string? status, CancellationToken cancellationToken)
    {
        SqlTenantGuard.Ensure(tenantId);
        var (limit, offset) = PaginatedQueryHelper.Normalize(page, pageSize);
        var sql = $"""
            SELECT id
            FROM {tableName}
            WHERE tenant_id = @TenantId
              AND excluido_em IS NULL
              AND (@Status IS NULL OR status = @Status)
            ORDER BY atualizado_em DESC, id
            LIMIT @Limit OFFSET @Offset;
            """;
        try
        {
            using var connection = await connectionFactory.OpenAsync(cancellationToken);
            var rows = await connection.QueryAsync<Guid>(new CommandDefinition(sql, new { TenantId = tenantId, Status = status, Limit = limit, Offset = offset }, cancellationToken: cancellationToken));
            return rows.AsList();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao listar ids reais em {TableName} para tenant {TenantId}.", tableName, tenantId);
            throw;
        }
    }

    protected async Task<bool> SoftDeleteAsync(Guid tenantId, Guid id, Guid? userId, CancellationToken cancellationToken)
    {
        SqlTenantGuard.Ensure(tenantId);
        var sql = $"""
            UPDATE {tableName}
            SET excluido_em = now(), atualizado_por_usuario_id = @UserId
            WHERE tenant_id = @TenantId AND id = @Id AND excluido_em IS NULL;
            """;
        try
        {
            using var connection = await connectionFactory.OpenAsync(cancellationToken);
            using var transaction = connection.BeginTransaction();
            var affected = await connection.ExecuteAsync(new CommandDefinition(sql, new { TenantId = tenantId, Id = id, UserId = userId }, transaction, cancellationToken: cancellationToken));
            await connection.ExecuteAsync(new CommandDefinition("""
                INSERT INTO integrarp.auditoria_evento (tenant_id, usuario_id, entidade, entidade_id, acao)
                VALUES (@TenantId, @UserId, @Entity, @Id, 'soft_delete');
                """, new { TenantId = tenantId, UserId = userId, Entity = tableName, Id = id }, transaction, cancellationToken: cancellationToken));
            transaction.Commit();
            return affected > 0;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao aplicar soft delete real em {TableName} para tenant {TenantId}.", tableName, tenantId);
            throw;
        }
    }
}
