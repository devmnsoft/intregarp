using System.Data;
using Dapper;
using IntegraRP.Infrastructure.Data;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Repositories.Postgres;

public sealed class PostgresConnectionFactory(IDbConnectionFactory inner, ILogger<PostgresConnectionFactory> logger)
{
    public async Task<IDbConnection> OpenAsync(CancellationToken cancellationToken)
    {
        try
        {
            return await inner.OpenConnectionAsync(cancellationToken);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao abrir conexão PostgreSQL do IntegraRP.");
            throw;
        }
    }
}

public static class SqlTenantGuard
{
    public static void Ensure(Guid tenantId)
    {
        if (tenantId == Guid.Empty)
        {
            throw new ArgumentException("tenant_id obrigatório para consultas operacionais.", nameof(tenantId));
        }
    }
}

public static class PaginatedQueryHelper
{
    public static (int Limit, int Offset) Normalize(int page, int pageSize)
    {
        var safePage = Math.Max(1, page);
        var safePageSize = Math.Clamp(pageSize, 1, 100);
        return (safePageSize, (safePage - 1) * safePageSize);
    }
}

public sealed class SqlOrderByWhitelist(params string[] allowedColumns)
{
    private readonly HashSet<string> _allowed = new(allowedColumns, StringComparer.OrdinalIgnoreCase);

    public string Resolve(string? requested, string fallback)
    {
        if (!string.IsNullOrWhiteSpace(requested) && _allowed.Contains(requested))
        {
            return requested;
        }

        if (!_allowed.Contains(fallback))
        {
            throw new InvalidOperationException("Ordenação padrão não está na whitelist SQL.");
        }

        return fallback;
    }
}

public sealed class RepositoryTransactionRunner(PostgresConnectionFactory connectionFactory, ILogger<RepositoryTransactionRunner> logger)
{
    public async Task ExecuteAsync(Func<IDbConnection, IDbTransaction, Task> action, CancellationToken cancellationToken)
    {
        using var db = await connectionFactory.OpenAsync(cancellationToken);
        using var transaction = db.BeginTransaction();
        try
        {
            await action(db, transaction);
            transaction.Commit();
        }
        catch (Exception ex)
        {
            transaction.Rollback();
            logger.LogError(ex, "Transação PostgreSQL revertida no repositório.");
            throw;
        }
    }
}

public sealed class PostgresRepositoryReadiness(PostgresConnectionFactory connectionFactory, ILogger<PostgresRepositoryReadiness> logger)
{
    public async Task<IReadOnlyList<string>> ListOperationalObjectsAsync(Guid tenantId, int page, int pageSize, CancellationToken cancellationToken)
    {
        SqlTenantGuard.Ensure(tenantId);
        var (limit, offset) = PaginatedQueryHelper.Normalize(page, pageSize);
        const string sql = """
            SELECT objeto
            FROM integrarp.v14_repository_status
            WHERE tenant_id = @TenantId
            ORDER BY objeto
            LIMIT @Limit OFFSET @Offset;
            """;

        try
        {
            using var connection = await connectionFactory.OpenAsync(cancellationToken);
            var rows = await connection.QueryAsync<string>(new CommandDefinition(sql, new { TenantId = tenantId, Limit = limit, Offset = offset }, cancellationToken: cancellationToken));
            return rows.AsList();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao consultar readiness v1.4 para tenant {TenantId}.", tenantId);
            throw;
        }
    }
}
