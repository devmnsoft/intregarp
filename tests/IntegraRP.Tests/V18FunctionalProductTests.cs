using Xunit;

namespace IntegraRP.Tests;

public sealed class V18FunctionalProductTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string PathOf(params string[] parts) => Path.Combine(new[] { Root }.Concat(parts).ToArray());
    private static string Read(params string[] parts) => File.ReadAllText(PathOf(parts));

    [Fact]
    public void ScriptCompleto_Deve_Conter_Objetos_V18_E_Regras_De_Schema()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.True(File.Exists(PathOf("database", "scriptcompleto.sql")));
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE EXTENSION IF NOT EXISTS pgcrypto", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS integrarp.v18_screen_audit", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS integrarp.v18_template_catalog", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS integrarp.v18_functional_validation_check", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS ix_v18_screen_audit_tenant_modulo_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS trg_v18_screen_audit_atualizado_em ON integrarp.v18_screen_audit", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW integrarp.vw_v18_dashboard_operacional", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("0020_v18_produto_funcional_cruds_telas_jornada", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Migration_0020_Deve_Ser_Idempotente_E_Usar_Somente_Integrarp()
    {
        var sql = Read("database", "migrations", "0020_v18_produto_funcional_cruds_telas_jornada.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ON CONFLICT", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Documentacao_V18_Deve_Existir()
    {
        foreach (var path in new[]
        {
            "docs/v1.8-functional-product.md",
            "docs/v1.8-functional-screen-audit.md",
            "docs/v1.8-crud-standard.md",
            "docs/v1.8-user-journeys.md",
            "docs/v1.8-template-catalog.md",
            "docs/v1.8-dashboard-guide.md",
            "docs/v1.8-web-layout-design-system.md",
            "docs/v1.8-api-functional-map.md",
            "docs/v1.8-worker-functional-processing.md",
            "docs/v1.8-mobile-functional-guide.md",
            "docs/v1.8-release-notes.md",
            "docs/v1.8-functional-validation-report.md",
            "docs/database-scriptcompleto.md"
        })
        {
            Assert.True(File.Exists(PathOf(path.Split('/'))), $"Documento obrigatório ausente: {path}");
        }
    }
}
