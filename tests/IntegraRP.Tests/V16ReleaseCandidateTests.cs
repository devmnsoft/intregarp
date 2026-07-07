using System.Text.Json;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V16ReleaseCandidateTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string PathOf(params string[] parts) => Path.Combine(new[] { Root }.Concat(parts).ToArray());
    private static string Read(params string[] parts) => File.ReadAllText(PathOf(parts));

    [Fact]
    public void ScriptCompleto_Deve_Conter_Objetos_V16_Idempotentes_E_Somente_Schema_Integrarp()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE EXTENSION IF NOT EXISTS pgcrypto", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS integrarp.v16_release_candidate_check", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS ix_v16_release_candidate_tenant_area_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION integrarp.fn_v16_release_candidate_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW integrarp.vw_v16_release_candidate_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS trg_v16_release_candidate_check_atualizado_em", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("0018_v16_release_candidate_validation", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void MigrationManifest_Deve_Listar_Migrations_E_Duplicidade_Historica_0014()
    {
        var manifestPath = PathOf("database", "migration_manifest.json");
        Assert.True(File.Exists(manifestPath));
        using var doc = JsonDocument.Parse(File.ReadAllText(manifestPath));
        var migrations = doc.RootElement.GetProperty("migrations").EnumerateArray().ToArray();
        Assert.Contains(migrations, m => m.GetProperty("arquivo").GetString() == "0018_v16_release_candidate_validation.sql");
        Assert.True(migrations.Count(m => m.GetProperty("versao").GetString() == "0014") > 1);
        Assert.All(migrations, m => Assert.Matches(@"^\d{4}_[a-z0-9_]+\.sql$", m.GetProperty("arquivo").GetString()!));
    }

    [Fact]
    public void Migrations_Nao_Devem_Usar_Schemas_Proibidos_E_Devem_Usar_Integrarp()
    {
        var files = Directory.GetFiles(PathOf("database", "migrations"), "*.sql");
        var numbers = files.GroupBy(f => Path.GetFileName(f)[..4]).ToDictionary(g => g.Key, g => g.Count());
        Assert.True(numbers["0014"] > 1); // duplicidade histórica documentada; novas duplicidades devem virar migration corretiva posterior.
        foreach (var file in files)
        {
            var sql = File.ReadAllText(file);
            Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
            Assert.Matches(@"^\d{4}_[a-z0-9_]+\.sql$", Path.GetFileName(file));
        }
    }

    [Fact]
    public void Workflows_E_Smoke_Scripts_De_V16_Devem_Existir()
    {
        foreach (var file in new[] { "ci.yml", "database-validation.yml", "release-candidate.yml" })
        {
            Assert.True(File.Exists(PathOf(".github", "workflows", file)), file);
        }

        foreach (var file in new[] { "db-apply-scriptcompleto.ps1", "db-validate-scriptcompleto.ps1", "validate-docker-release.ps1", "smoke-test-api.ps1", "smoke-test-customer-journey.ps1" })
        {
            Assert.True(File.Exists(PathOf("scripts", file)), file);
        }
    }
}
