using IntegraRP.Domain.Journey;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V12JourneyTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void Banco_Deve_Conter_Jornada_Adocao_Views_E_Regras_Idempotentes()
    {
        var sql = Read("database", "scriptcompleto.sql");
        var migration = Read("database", "migrations", "0014_v12_jornada_cliente_onboarding_ux.sql");
        foreach (var content in new[] { sql, migration })
        {
            Assert.DoesNotContain("public.", content, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("integra.", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("integrarp.jornada_cliente", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("integrarp.jornada_acao_recomendada", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("integrarp.adocao_score", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("integrarp.vw_o_que_fazer_agora", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("CREATE TABLE IF NOT EXISTS", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("CREATE INDEX IF NOT EXISTS", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("CREATE OR REPLACE FUNCTION", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("DROP TRIGGER IF EXISTS", content, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("IF NOT EXISTS (SELECT 1 FROM pg_constraint", content, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Domain_Jornada_Sem_Etapa_Falha()
    {
        var journey = new CustomerJourney(Guid.NewGuid(), null, "primeiros-passos", "Primeiros passos");
        Assert.Throws<InvalidOperationException>(() => journey.EnsureCanPublish());
    }

    [Fact]
    public void Domain_Progresso_Nao_Passa_De_Cem()
    {
        Assert.Throws<ArgumentOutOfRangeException>(() => new JourneyProgressPercent(101));
    }

    [Fact]
    public void Domain_Etapa_Bloqueada_Nao_Conclui()
    {
        var progress = new UserJourneyProgress(Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid());
        progress.Block();
        Assert.Throws<InvalidOperationException>(() => progress.CompleteStep(50));
    }

    [Fact]
    public void Domain_Acao_Recomendada_Concluida_Nao_Conclui_Novamente()
    {
        var action = new RecommendedAction(Guid.NewGuid(), Guid.NewGuid(), "Criar primeiro pedido", new RecommendedActionReason("onboarding"));
        action.Complete();
        Assert.Throws<InvalidOperationException>(() => action.Complete());
    }

    [Fact]
    public void Web_Assets_E_Rotas_De_Onboarding_Devem_Existir()
    {
        string[] files = [
            "src/IntegraRP.Web/wwwroot/js/journey-api.js",
            "src/IntegraRP.Web/wwwroot/js/onboarding.js",
            "src/IntegraRP.Web/wwwroot/js/what-to-do-now.js",
            "src/IntegraRP.Web/wwwroot/js/contextual-help.js",
            "src/IntegraRP.Web/wwwroot/js/guided-tour.js",
            "src/IntegraRP.Web/wwwroot/js/empty-state-guidance.js",
            "src/IntegraRP.Web/wwwroot/js/user-feedback.js",
            "src/IntegraRP.Web/wwwroot/css/journey.css",
            "src/IntegraRP.Web/wwwroot/css/onboarding.css",
            "src/IntegraRP.Web/wwwroot/css/contextual-help.css",
            "src/IntegraRP.Web/wwwroot/css/guided-tour.css",
            "src/IntegraRP.Web/wwwroot/css/empty-state.css"
        ];
        foreach (var file in files) Assert.True(File.Exists(Path.Combine(Root, file)), file);
        var controller = Read("src", "IntegraRP.Web", "Controllers", "OnboardingController.cs");
        Assert.Contains("onboarding/first-order", controller, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("onboarding/templates", controller, StringComparison.OrdinalIgnoreCase);
    }
}
