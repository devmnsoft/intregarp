using System.Text.Json;
using System.Text.RegularExpressions;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V16ReleaseCandidateTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string PathOf(params string[] parts) => Path.Combine(new[] { Root }.Concat(parts).ToArray());
    private static string Read(params string[] parts) => File.ReadAllText(PathOf(parts));

    [Fact]
    public void ScriptCompleto_Deve_Conter_Governanca_V16_E_Ser_Estaticamente_Idempotente()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ALTER TABLE integrarp.v16_release_candidate_check ADD COLUMN IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW integrarp.vw_v16_release_candidate_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("0018_v16_release_candidate_validation", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Migrations_Deve_Ter_Numeracao_Unica_Padrao_E_Schema_Correto()
    {
        var migrations = Directory.GetFiles(PathOf("database", "migrations"), "*.sql").Select(Path.GetFileName).Order().ToArray();
        Assert.All(migrations, name => Assert.Matches(@"^\d{4}_[a-z0-9_]+\.sql$", name!));
        var duplicates = migrations.GroupBy(name => name![..4]).Where(group => group.Count() > 1).Select(group => group.Key).ToArray();
        Assert.Contains("0014", duplicates); // duplicidade histórica documentada e preservada no manifest.
        Assert.Equal(new[] { "0014" }, duplicates);

        foreach (var file in migrations)
        {
            var sql = Read("database", "migrations", file!);
            Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Manifest_Deve_Listar_Migrations_E_ScriptCompleto()
    {
        var manifestPath = PathOf("database", "migration_manifest.json");
        Assert.True(File.Exists(manifestPath));
        using var doc = JsonDocument.Parse(File.ReadAllText(manifestPath));
        var entries = doc.RootElement.GetProperty("migrations").EnumerateArray().ToArray();
        Assert.Contains(entries, e => e.GetProperty("arquivo").GetString() == "0018_v16_release_candidate_validation.sql");
        Assert.All(entries, e => Assert.True(e.TryGetProperty("presente_no_scriptcompleto", out _)));
    }

    [Fact]
    public void Workflows_E_Scripts_De_Release_Candidate_Devem_Existir()
    {
        foreach (var path in new[]
        {
            ".github/workflows/ci.yml",
            ".github/workflows/database-validation.yml",
            ".github/workflows/release-candidate.yml",
            "scripts/db-validate-scriptcompleto.ps1",
            "scripts/validate-docker-release.ps1",
            "scripts/smoke-test-customer-journey.ps1"
        })
        {
            Assert.True(File.Exists(PathOf(path.Split('/'))), $"Arquivo obrigatório ausente: {path}");
        }
    }
}
