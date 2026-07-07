using System.Data;
using Dapper;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Repositories.Postgres;

public sealed record V15OperationalRow(Guid Id, Guid TenantId, string Modulo, string Objeto, string Status, DateTimeOffset CriadoEm, DateTimeOffset AtualizadoEm);
public sealed record V15JourneyCheck(Guid Id, Guid TenantId, int StepOrder, string Step, string Status, string Message);

public abstract class PostgresTenantScopedRepository(PostgresConnectionFactory connectionFactory, ILogger logger, string tableName)
{
    protected async Task<IReadOnlyList<V15OperationalRow>> ListRowsAsync(Guid tenantId, int page, int pageSize, CancellationToken cancellationToken)
    {
        SqlTenantGuard.Ensure(tenantId);
        var (limit, offset) = PaginatedQueryHelper.Normalize(page, pageSize);
        var sql = $"""
            SELECT id AS Id, tenant_id AS TenantId, modulo AS Modulo, objeto AS Objeto, status AS Status, criado_em AS CriadoEm, atualizado_em AS AtualizadoEm
            FROM {tableName}
            WHERE tenant_id = @TenantId
            ORDER BY atualizado_em DESC, id
            LIMIT @Limit OFFSET @Offset;
            """;

        try
        {
            using var connection = await connectionFactory.OpenAsync(cancellationToken);
            var rows = await connection.QueryAsync<V15OperationalRow>(new CommandDefinition(sql, new { TenantId = tenantId, Limit = limit, Offset = offset }, cancellationToken: cancellationToken));
            return rows.AsList();
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao listar objetos operacionais PostgreSQL para tenant {TenantId}.", tenantId);
            throw;
        }
    }

    protected async Task<Guid> UpsertRowAsync(Guid tenantId, string modulo, string objeto, string status, CancellationToken cancellationToken)
    {
        SqlTenantGuard.Ensure(tenantId);
        const string sql = """
            INSERT INTO integrarp.v15_operational_object (tenant_id, modulo, objeto, rota_api, rota_web, repositorio_postgres, status)
            VALUES (@TenantId, @Modulo, @Objeto, @RotaApi, @RotaWeb, @RepositorioPostgres, @Status)
            ON CONFLICT (tenant_id, modulo, objeto) DO UPDATE SET status = EXCLUDED.status, atualizado_em = now()
            RETURNING id;
            """;

        try
        {
            using var connection = await connectionFactory.OpenAsync(cancellationToken);
            using var transaction = connection.BeginTransaction();
            var id = await connection.ExecuteScalarAsync<Guid>(new CommandDefinition(sql, new
            {
                TenantId = tenantId,
                Modulo = modulo,
                Objeto = objeto,
                RotaApi = $"/api/{objeto.ToLowerInvariant()}",
                RotaWeb = $"/{objeto.ToLowerInvariant()}",
                RepositorioPostgres = GetType().Name,
                Status = status
            }, transaction, cancellationToken: cancellationToken));
            transaction.Commit();
            return id;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao salvar objeto operacional PostgreSQL {Objeto} para tenant {TenantId}.", objeto, tenantId);
            throw;
        }
    }
}

public sealed class PostgresTenantRepository(PostgresConnectionFactory f, ILogger<PostgresTenantRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresUserRepository(PostgresConnectionFactory f, ILogger<PostgresUserRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresProfileRepository(PostgresConnectionFactory f, ILogger<PostgresProfileRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresPermissionRepository(PostgresConnectionFactory f, ILogger<PostgresPermissionRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresSectorRepository(PostgresConnectionFactory f, ILogger<PostgresSectorRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresCustomerRepository(PostgresConnectionFactory f, ILogger<PostgresCustomerRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresProductRepository(PostgresConnectionFactory f, ILogger<PostgresProductRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresStockRepository(PostgresConnectionFactory f, ILogger<PostgresStockRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresOrderRepository(PostgresConnectionFactory f, ILogger<PostgresOrderRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresProcessRepository(PostgresConnectionFactory f, ILogger<PostgresProcessRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresWorkflowTaskRepository(PostgresConnectionFactory f, ILogger<PostgresWorkflowTaskRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresInvoiceRepository(PostgresConnectionFactory f, ILogger<PostgresInvoiceRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresFinancialTitleRepository(PostgresConnectionFactory f, ILogger<PostgresFinancialTitleRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresOutboxRepository(PostgresConnectionFactory f, ILogger<PostgresOutboxRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresProjectRepository(PostgresConnectionFactory f, ILogger<PostgresProjectRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresJourneyRepository(PostgresConnectionFactory f, ILogger<PostgresJourneyRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresRecommendedActionRepository(PostgresConnectionFactory f, ILogger<PostgresRecommendedActionRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
public sealed class PostgresAuditRepository(PostgresConnectionFactory f, ILogger<PostgresAuditRepository> l) : PostgresTenantScopedRepository(f, l, "integrarp.v15_operational_object") { }
