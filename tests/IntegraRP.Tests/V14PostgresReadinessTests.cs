using Xunit;

namespace IntegraRP.Tests;

public sealed class V14PostgresReadinessTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void ScriptCompleto_Deve_Conter_Objetos_V14_Idempotentes()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.v14_repository_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.v14_operational_demo_run", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.vw_v14_order_to_billing_demo", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Migration0016_Deve_Existir_E_Usar_Apenas_Integrarp()
    {
        var sql = Read("database", "migrations", "0016_v14_postgres_repositories_operacional.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE EXTENSION IF NOT EXISTS pgcrypto", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS integrarp.v14_repository_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW integrarp.vw_v14_order_to_billing_demo", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Repositorios_Postgres_Deve_Ter_Guards_Dapper_Paginacao_E_Sem_Select_Star()
    {
        var source = Read("src", "IntegraRP.Infrastructure", "Repositories", "Postgres", "PostgresRepositorySupport.cs");
        Assert.Contains("Dapper", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("tenant_id = @TenantId", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("LIMIT @Limit OFFSET @Offset", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CancellationToken", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ILogger", source, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("SELECT *", source, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void FunctionalValidation_Deve_Expor_Demo_V14()
    {
        var source = Read("src", "IntegraRP.Api", "Controllers", "FunctionalValidationController.cs");
        Assert.Contains("flow/order-to-billing-demo", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("vw_v14_order_to_billing_demo", source, StringComparison.OrdinalIgnoreCase);
    }
}
