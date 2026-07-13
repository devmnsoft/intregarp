using Xunit;

namespace IntegraRP.Tests;

public sealed class V113FunctionalConsolidationTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void Fluxos_Essenciais_Nao_Devem_Retornar_501()
    {
        foreach (var file in new[] { "CustomersController.cs", "ProductsController.cs", "InventoryController.cs", "OrdersController.cs", "TasksController.cs" })
        {
            var source = Read("src", "IntegraRP.Api", "Controllers", file);
            Assert.DoesNotContain("statusCode: 501", source, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("NotImplemented", source, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("throw new NotImplementedException", source, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Runtime_Deve_Expor_Consultas_Detalhes_Soft_Delete_E_Acoes_Operacionais()
    {
        var useCases = Read("src", "IntegraRP.Application", "Runtime", "OperationalRuntimeUseCases.cs");
        foreach (var member in new[]
        {
            "GetCustomerAsync", "DeleteCustomerAsync", "GetProductAsync", "DeleteProductAsync",
            "ListInventoryBalanceAsync", "ListInventoryMovementsAsync", "ListCriticalInventoryAsync",
            "GetOrderAsync", "CreateOrderAsync", "AddOrderItemAsync", "RemoveOrderItemAsync", "CancelOrderAsync",
            "GetTaskAsync", "ClaimTaskAsync", "CommentTaskAsync"
        })
        {
            Assert.Contains(member, useCases, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Repository_Operacional_Deve_Manter_Tenant_Soft_Delete_E_Schema_Integrarp()
    {
        var repository = Read("src", "IntegraRP.Infrastructure", "Repositories", "Postgres", "PostgresV112OperationalRepository.cs");
        Assert.Contains("tenant_id=@tenant_id", repository, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("excluido_em", repository, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.cliente", repository, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.produto", repository, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.pedido", repository, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.tarefa_operacional", repository, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain(" public.", repository, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain(" integra.", repository, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Documentacao_V113_Deve_Registrar_Validacao_E_Limitacoes_Reais()
    {
        var validation = Read("docs", "v1.13-build-db-validation.md");
        var limitations = Read("docs", "v1.13-known-limitations.md");
        Assert.Contains("dotnet", validation, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("psql", validation, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("limitações", limitations, StringComparison.OrdinalIgnoreCase);
    }
}
