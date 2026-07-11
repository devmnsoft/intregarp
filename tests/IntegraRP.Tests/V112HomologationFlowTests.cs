using Xunit;

namespace IntegraRP.Tests;

public sealed class V112HomologationFlowTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void Homologacao_Deve_Expor_Checks_Visuais_E_Status_De_Worker()
    {
        var api = Read("src", "IntegraRP.Api", "Controllers", "V112HomologationController.cs");
        foreach (var route in new[] { "api/homologation/status", "api/homologation/run-all", "api/homologation/run-check/{checkCode}", "api/validation/worker/status" })
        {
            Assert.Contains(route, api, StringComparison.OrdinalIgnoreCase);
        }

        foreach (var check in new[] { "clientes", "produtos", "estoque", "pedidos", "tarefas", "faturamento", "outbox", "templates" })
        {
            Assert.Contains(check, api, StringComparison.OrdinalIgnoreCase);
        }

        Assert.Contains("integrarp.outbox_evento", api, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Web_Deve_Ter_Menu_Homologacao_Templates_E_Aliases_De_Aceite()
    {
        var layout = Read("src", "IntegraRP.Web", "Views", "Shared", "_Layout.cshtml");
        Assert.Contains("Homologação", layout, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("/homologation", layout, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("/templates", layout, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("/connect/outbox", layout, StringComparison.OrdinalIgnoreCase);

        var outbox = Read("src", "IntegraRP.Api", "Controllers", "Connect", "OutboxController.cs");
        Assert.Contains("[Route(\"api/outbox\")]", outbox, StringComparison.OrdinalIgnoreCase);

        var titles = Read("src", "IntegraRP.Api", "Controllers", "Billing", "FinancialTitlesController.cs");
        Assert.Contains("{id:guid}/fake-boleto", titles, StringComparison.OrdinalIgnoreCase);

        var invoices = Read("src", "IntegraRP.Api", "Controllers", "Billing", "InvoicesController.cs");
        Assert.Contains("{id:guid}/titles", invoices, StringComparison.OrdinalIgnoreCase);
    }
}
