using Xunit;

namespace IntegraRP.Tests;

public sealed class V12DatabaseTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void ScriptCompleto_Deve_Conter_V12_Idempotente_Somente_Integrarp()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE EXTENSION IF NOT EXISTS pgcrypto", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("IF NOT EXISTS (SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.integracao_conector", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.fiscal_documento", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.financeiro_conciliacao", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.rota_otimizacao_execucao", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.offline_dispositivo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("secret_reference", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DANFE HTML fake demo", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Migration0014_Deve_Existir_E_Conter_Tabelas_V12()
    {
        var sql = Read("database", "migrations", "0014_v12_integracoes_fiscal_conciliacao_rotas_offline.sql");
        foreach (var table in new[] { "integracao_execucao_log", "fiscal_emissao_lote", "financeiro_extrato_lancamento", "rota_distancia_cache", "offline_conflito" })
            Assert.Contains($"integrarp.{table}", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
    }
}
