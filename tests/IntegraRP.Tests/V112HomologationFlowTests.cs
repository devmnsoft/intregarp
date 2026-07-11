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

public sealed class V112CleanRuntimeArchitectureTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void Runtime_Controllers_Nao_Devem_Conter_Sql_Npgsql_Ou_AllowAnonymous()
    {
        foreach (var file in new[] { "V110RuntimeController.cs", "CustomersController.cs", "ProductsController.cs", "InventoryController.cs", "OrdersController.cs", "TasksController.cs" })
        {
            var source = Read("src", "IntegraRP.Api", "Controllers", file);
            Assert.DoesNotContain("AllowAnonymous", source, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("Npgsql", source, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("SELECT ", source, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("INSERT ", source, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("UPDATE ", source, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("DELETE ", source, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("Authorize", source, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Runtime_Deve_Usar_UseCase_E_Repository_Postgres_Na_Infrastructure()
    {
        var useCases = Read("src", "IntegraRP.Application", "Runtime", "OperationalRuntimeUseCases.cs");
        var repository = Read("src", "IntegraRP.Infrastructure", "Repositories", "Postgres", "PostgresV112OperationalRepository.cs");

        Assert.Contains("Result<", useCases, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("IOperationalRuntimeRepository", useCases, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("tenant_id=@tenant_id", repository, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("using Npgsql", repository, StringComparison.OrdinalIgnoreCase);
    }
}
