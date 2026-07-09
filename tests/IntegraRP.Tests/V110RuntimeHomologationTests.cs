using Xunit;

namespace IntegraRP.Tests;

public sealed class V110RuntimeHomologationTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string PathOf(params string[] parts) => Path.Combine(new[] { Root }.Concat(parts).ToArray());
    private static string Read(params string[] parts) => File.ReadAllText(PathOf(parts));

    [Fact]
    public void RuntimeController_Deve_Expor_Cruds_Minimos_Com_Acoes_Reais_No_Banco()
    {
        var source = Read("src", "IntegraRP.Api", "Controllers", "V110RuntimeController.cs");

        foreach (var route in new[] { "api", "customers", "products", "inventory/entries", "orders/{id:guid}/confirm", "tasks/{id:guid}/complete" })
        {
            Assert.Contains(route, source, StringComparison.OrdinalIgnoreCase);
        }

        Assert.Contains("INSERT INTO integrarp.cliente", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("INSERT INTO integrarp.produto", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("INSERT INTO integrarp.estoque_movimento", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("UPDATE integrarp.pedido SET status='confirmado'", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("UPDATE integrarp.tarefa_operacional SET status='concluida'", source, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("Ok(new { status = \"ok\"", source, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Journey_Acoes_Recomendadas_Devem_Persistir_Status_Real()
    {
        var source = Read("src", "IntegraRP.Api", "Controllers", "JourneyController.cs");

        Assert.Contains("UPDATE integrarp.jornada_acao_recomendada SET status='concluida'", source, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("UPDATE integrarp.jornada_acao_recomendada SET status='ignorada'", source, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("Ok(new { id, status = \"concluida\" })", source, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("Ok(new { id, status = \"ignorada\" })", source, StringComparison.OrdinalIgnoreCase);
    }
}
