using Xunit;

namespace IntegraRP.Tests;

public sealed class V19DemoFunctionalTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string PathOf(params string[] parts) => Path.Combine(new[] { Root }.Concat(parts).ToArray());
    private static string Read(params string[] parts) => File.ReadAllText(PathOf(parts));

    [Fact]
    public void ScriptCompleto_Deve_Conter_V19_Views_Seeds_E_Sem_Schemas_Indevidos()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("V1.9 - SEED DEMO FUNCIONAL COMPLETO", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.atividade_operacional", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.vw_v19_demo_funcional_status", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.vw_v19_o_que_fazer_agora", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ON CONFLICT (tenant_id,codigo) WHERE excluido_em IS NULL DO UPDATE", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Artefatos_De_Validacao_Apis_E_Telas_Devem_Existir()
    {
        foreach (var path in new[]
        {
            "database/validation/validate_scriptcompleto_v19.sql",
            "database/migrations/0021_v19_fix_scriptcompleto_inserts_demo_jornada.sql",
            "scripts/db-debug-scriptcompleto.ps1",
            "scripts/db-debug-scriptcompleto.cmd",
            "src/IntegraRP.Api/Controllers/ActivitiesController.cs",
            "src/IntegraRP.Api/Controllers/DemoController.cs",
            "src/IntegraRP.Web/Controllers/ActivitiesController.cs",
            "src/IntegraRP.Web/Controllers/DemoController.cs",
            "src/IntegraRP.Web/Views/Activities/Index.cshtml",
            "src/IntegraRP.Web/Views/Demo/Index.cshtml",
            "src/IntegraRP.Web/wwwroot/js/activities.js",
            "src/IntegraRP.Web/wwwroot/js/demo.js",
            "src/IntegraRP.Web/wwwroot/js/dashboard.js"
        }) Assert.True(File.Exists(PathOf(path.Split('/'))), $"Arquivo obrigatório ausente: {path}");
    }

    [Fact]
    public void Controllers_Devem_Expor_Endpoints_V19()
    {
        var activities = Read("src", "IntegraRP.Api", "Controllers", "ActivitiesController.cs");
        var demo = Read("src", "IntegraRP.Api", "Controllers", "DemoController.cs");
        var journey = Read("src", "IntegraRP.Api", "Controllers", "JourneyController.cs");
        var validation = Read("src", "IntegraRP.Api", "Controllers", "V19JourneyValidationController.cs");
        Assert.Contains("Route(\"api/activities\")", activities);
        Assert.Contains("HttpGet", activities);
        Assert.Contains("api/demo", demo);
        Assert.Contains("run-all", demo);
        Assert.Contains("what-to-do-now", journey);
        Assert.DoesNotContain("new[] { new { titulo = \"Continuar onboarding\"", journey);
        Assert.Contains("e2e/customer-to-billing", validation);
        Assert.Contains("vw_v19_demo_funcional_status", validation);
        Assert.Contains("worker/status", validation);
    }
}
