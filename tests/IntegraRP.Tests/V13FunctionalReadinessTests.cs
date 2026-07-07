using Xunit;

namespace IntegraRP.Tests;

public sealed class V13FunctionalReadinessTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void ScriptCompleto_Deve_Conter_Objetos_V13_Idempotentes_Somente_Integrarp()
    {
        var sql = Read("database", "scriptcompleto.sql");

        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE EXTENSION IF NOT EXISTS pgcrypto", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ALTER TABLE integrarp.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ADD COLUMN IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);

        foreach (var expected in V13Objects)
        {
            Assert.Contains(expected, sql, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Migration0015_Deve_Existir_E_Conter_Views_De_Validacao()
    {
        var sql = Read("database", "migrations", "0015_v13_funcionalidade_real_end_to_end.sql");

        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);

        foreach (var expected in V13Objects)
        {
            Assert.Contains(expected, sql, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void FunctionalValidationController_Deve_Expor_Endpoints_E_Permissao()
    {
        var source = Read("src", "IntegraRP.Api", "Controllers", "FunctionalValidationController.cs");

        Assert.Contains("validation.functional.visualizar", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("health/end-to-end", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("demo/status", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("repositories/status", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("screens/status", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("tenant-isolation/status", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("scriptcompleto/status", source, StringComparison.OrdinalIgnoreCase);
    }

    private static readonly string[] V13Objects =
    [
        "integrarp.v13_funcionalidade_status",
        "integrarp.v13_recommended_action",
        "integrarp.v13_demo_execucao",
        "integrarp.vw_v13_fluxo_pedido_end_to_end",
        "integrarp.vw_v13_telas_com_dados_reais",
        "integrarp.vw_v13_pendencias_funcionais",
        "integrarp.vw_v13_modulos_com_repositorio_real",
        "integrarp.vw_v13_o_que_fazer_agora_real",
        "integrarp.vw_v13_demo_health",
        "0015_v13_funcionalidade_real_end_to_end"
    ];
}
