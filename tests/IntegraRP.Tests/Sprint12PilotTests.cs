using Xunit;

namespace IntegraRP.Tests;

public sealed class Sprint12PilotTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");

    [Fact]
    public void Migration0012_Deve_Conter_Dados_Demo_E_Views_Do_Piloto()
    {
        var sql = File.ReadAllText(Path.Combine(Root, "database", "migrations", "0012_piloto_v1_final_adjustments.sql"));

        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.piloto_v1_demo_catalogo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Valora Group & MNSoft Demo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("admin@integrarp.local", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Processo Pedido ao Pós-venda", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Controle de Avarias", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Board Project Demo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Rota, Romaneio e POD Demo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("vw_piloto_validacao_fluxos", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("vw_piloto_saude_operacional", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("vw_piloto_dados_demo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("vw_piloto_pendencias", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void DocumentacaoObrigatoria_Do_Piloto_Deve_Existir()
    {
        string[] docs =
        [
            "deploy-iis-windows-server.md",
            "homologation-plan.md",
            "homologation-test-cases.md",
            "training-plan.md",
            "demo-executive-script.md",
            "demo-operational-script.md",
            "demo-technical-script.md",
            "release-notes-v1.0.md",
            "go-live-plan.md",
            "rollback-plan.md",
            "runbook-pilot-operations.md",
            "pilot-acceptance-checklist.md",
            "pilot-demo-credentials.md"
        ];

        foreach (var doc in docs)
        {
            var path = Path.Combine(Root, "docs", doc);
            Assert.True(File.Exists(path), $"Documento obrigatório ausente: {doc}");
            Assert.True(new FileInfo(path).Length > 200, $"Documento obrigatório muito curto: {doc}");
        }
    }

    [Fact]
    public void ScriptsObrigatorios_Do_Piloto_Deve_Existir()
    {
        string[] scripts =
        [
            "validate-pilot-windows.ps1",
            "validate-pilot-windows.cmd",
            "run-pilot-api-windows.ps1",
            "run-pilot-web-windows.ps1",
            "run-pilot-worker-windows.ps1",
            "validate-pilot-docker.ps1",
            "reset-pilot-docker.ps1"
        ];

        foreach (var script in scripts)
        {
            Assert.True(File.Exists(Path.Combine(Root, "scripts", script)), $"Script obrigatório ausente: {script}");
        }
    }

    [Fact]
    public void DockerPilot_Deve_Configurar_Healthchecks_E_ConnectionStrings()
    {
        var compose = File.ReadAllText(Path.Combine(Root, "docker-compose.pilot.yml"));
        var env = File.ReadAllText(Path.Combine(Root, ".env.pilot.example"));

        Assert.Contains("Host=postgres", compose, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("api/health/live", compose, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("service_healthy", compose, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("troque_esta_senha", env, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("secret", env, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void ReleaseNotes_Deve_Explicitar_Limitacoes_FakeLog()
    {
        var release = File.ReadAllText(Path.Combine(Root, "docs", "release-notes-v1.0.md"));

        Assert.Contains("WhatsApp real ainda não implementado", release, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("IA externa real ainda não implementada", release, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("NF-e real ainda não implementada", release, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Integrações bancárias reais ainda não implementadas", release, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("Mapas/roteirização real ainda não implementados", release, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("fake/log", release, StringComparison.OrdinalIgnoreCase);
    }
}
