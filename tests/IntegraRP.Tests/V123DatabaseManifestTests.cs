using System.Text.Json;
using System.Text.RegularExpressions;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V123DatabaseManifestTests
{
    private static readonly string Root = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", ".."));

    [Fact]
    public void Script_Completo_Deve_Estar_Versionado_Como_V123_Com_29_Migrations()
    {
        var script = File.ReadAllText(Path.Combine(Root, "database", "script_completop.sql"));
        Assert.Contains("-- Produto: IntegraRP", script);
        Assert.Contains("-- Versão: v1.23", script);
        Assert.Contains("-- PostgreSQL: 16", script);
        Assert.Contains("-- Schema: integrarp", script);
        Assert.Contains("-- Número de migrations: 29", script);
        Assert.Contains("-- >>> 0028_v122_release_candidate_core_real.sql", script);
        Assert.Contains("-- >>> 0029_v123_core_operacional_real.sql", script);
    }

    [Fact]
    public void Script_Completo_E_Compatibilidade_Devem_Ser_Identicos()
    {
        var canonical = File.ReadAllBytes(Path.Combine(Root, "database", "script_completop.sql"));
        var compatibility = File.ReadAllBytes(Path.Combine(Root, "database", "scriptcompleto.sql"));
        Assert.Equal(canonical, compatibility);
    }

    [Fact]
    public void Manifest_Deve_Incluir_Somente_Migrations_Presentes_No_Script_Completo()
    {
        using var doc = JsonDocument.Parse(File.ReadAllText(Path.Combine(Root, "database", "migration_manifest.json")));
        Assert.Equal("v1.23", doc.RootElement.GetProperty("gerado_para").GetString());
        var migrations = doc.RootElement.GetProperty("migrations").EnumerateArray().ToArray();
        Assert.Equal(29, migrations.Length);
        var script = File.ReadAllText(Path.Combine(Root, "database", "script_completop.sql"));

        foreach (var migration in migrations)
        {
            Assert.True(migration.GetProperty("presente_no_script_completop").GetBoolean());
            var fileName = migration.GetProperty("arquivo").GetString();
            Assert.False(string.IsNullOrWhiteSpace(fileName));
            Assert.Contains($"-- >>> {fileName}", script);
        }
    }

    [Fact]
    public void Migration_0028_Nao_Deve_Controlar_Transacao_Nem_Ser_Apenas_Marcador_No_Script()
    {
        var migration = File.ReadAllText(Path.Combine(Root, "database", "migrations", "0028_v122_release_candidate_core_real.sql"));
        Assert.DoesNotMatch(new Regex(@"^\s*BEGIN\s*;", RegexOptions.IgnoreCase | RegexOptions.Multiline), migration);
        Assert.DoesNotMatch(new Regex(@"^\s*COMMIT\s*;", RegexOptions.IgnoreCase | RegexOptions.Multiline), migration);

        var script = File.ReadAllText(Path.Combine(Root, "database", "script_completop.sql"));
        Assert.Contains("integrarp.release_candidate_evidencia", script);
    }

    [Fact]
    public void Migration_0029_Deve_Ser_Aditiva_Operacional_E_Sem_SearchPath()
    {
        var migration = File.ReadAllText(Path.Combine(Root, "database", "migrations", "0029_v123_core_operacional_real.sql"));
        Assert.DoesNotContain("search_path", migration, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain(" public.", migration, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.auth_login_attempt", migration);
        Assert.Contains("integrarp.auth_password_history", migration);
        Assert.Contains("integrarp.worker_tenant_job_lock", migration);
        Assert.Contains("integrarp.vw_dashboard_operacional", migration);
    }
}
