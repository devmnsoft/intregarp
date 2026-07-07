using Xunit;

namespace IntegraRP.Tests;

public sealed class V15OperationalReadinessTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void ScriptCompleto_Deve_Conter_Objetos_V15_Idempotentes()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE EXTENSION IF NOT EXISTS pgcrypto", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS integrarp.v15_operational_object", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS ix_v15_operational_object_tenant_modulo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION integrarp.fn_v15_customer_full_journey_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS trg_v15_operational_object_atualizado_em", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW integrarp.vw_v15_customer_full_journey", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("0017_v15_validacao_real_cruds_qa_deploy", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Migration0017_Deve_Existir_E_Ser_Idempotente()
    {
        var sql = Read("database", "migrations", "0017_v15_validacao_real_cruds_qa_deploy.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ALTER TABLE integrarp.v15_operational_object ADD COLUMN IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ON CONFLICT", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Repositorios_Postgres_V15_Deve_Existir_Com_Tenant_Paginacao_Parametros_E_Sem_Select_Star()
    {
        var source = Read("src", "IntegraRP.Infrastructure", "Repositories", "Postgres", "V15OperationalRepositories.cs");
        foreach (var repository in new[] { "PostgresTenantRepository", "PostgresUserRepository", "PostgresProfileRepository", "PostgresPermissionRepository", "PostgresSectorRepository", "PostgresCustomerRepository", "PostgresProductRepository", "PostgresStockRepository", "PostgresOrderRepository", "PostgresProcessRepository", "PostgresWorkflowTaskRepository", "PostgresInvoiceRepository", "PostgresFinancialTitleRepository", "PostgresOutboxRepository", "PostgresProjectRepository", "PostgresJourneyRepository", "PostgresRecommendedActionRepository", "PostgresAuditRepository" })
        {
            Assert.Contains(repository, source, StringComparison.OrdinalIgnoreCase);
        }

        Assert.Contains("Dapper", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("tenant_id = @TenantId", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("LIMIT @Limit OFFSET @Offset", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CancellationToken", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ILogger", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("BeginTransaction", source, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("SELECT *", source, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void FunctionalValidation_Deve_Expor_Jornada_Completa_Do_Cliente()
    {
        var source = Read("src", "IntegraRP.Api", "Controllers", "FunctionalValidationController.cs");
        Assert.Contains("flow/customer-full-journey", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("generatedIds", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("flow/order-to-billing-demo", source, StringComparison.OrdinalIgnoreCase);
    }
}
