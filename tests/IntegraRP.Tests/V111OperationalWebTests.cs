using Xunit;

namespace IntegraRP.Tests;

public sealed class V111OperationalWebTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void Telas_Operacionais_Devem_Consumir_Endpoints_Reais_E_Expor_Acoes()
    {
        var js = Read("src", "IntegraRP.Web", "wwwroot", "js", "operational-cruds.js");
        foreach (var endpoint in new[] { "/api/customers", "/api/products", "/api/inventory/entries", "/api/orders", "/api/tasks/my" })
        {
            Assert.Contains(endpoint, js, StringComparison.OrdinalIgnoreCase);
        }

        Assert.Contains("method:f.id?'PUT':'POST'", js, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("/confirm", js, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("/complete", js, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("confirm('Confirmar este pedido?')", js, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("confirm('Concluir tarefa?')", js, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Runtime_Deve_Permitir_Edicao_De_Clientes_E_Produtos()
    {
        var source = Read("src", "IntegraRP.Api", "Controllers", "V110RuntimeController.cs");
        Assert.Contains("[HttpPut(\"customers/{id:guid}\")]", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("UPDATE integrarp.cliente", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("[HttpPut(\"products/{id:guid}\")]", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("UPDATE integrarp.produto", source, StringComparison.OrdinalIgnoreCase);
    }
}
