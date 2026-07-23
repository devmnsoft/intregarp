using IntegraRP.Domain.Commercial;
using IntegraRP.Infrastructure.Data.Migrations;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V129CommercialJourneyTests
{
    [Fact]
    public void Policies_Rejeitam_Valores_Invalidos_Da_Jornada_Comercial()
    {
        Assert.Equal("Nome do cliente é obrigatório.", CustomerPolicy.Validate("", null, null));
        Assert.Equal("Categoria é obrigatória.", ProductPolicy.ValidateProduct("SKU", "Produto", Guid.Empty, 0, 0));
        Assert.Equal("Quantidade deve ser maior que zero.", InventoryPolicy.ValidateMovement(Guid.NewGuid(), Guid.NewGuid(), 0, "CD", "entrada", Guid.NewGuid(), "idem"));
        Assert.True(OrderStateMachine.CanAddItem(OrderStateMachine.Draft));
        Assert.True(TaskStateMachine.CanTransition(TaskStateMachine.InProgress, TaskStateMachine.Done));
    }

    [Fact]
    public void Manifesto_V129_Deve_Ser_Tipado_E_Rejeitar_Duplicidade_Nova()
    {
        var root = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", ".."));
        var manifest = MigrationManifestLoader.Load(Path.Combine(root, "database", "migration_manifest.json"));
        Assert.Equal("v1.29", manifest.GeneratedFor);
        Assert.Equal(35, manifest.Migrations.Count);
        var errors = new MigrationManifestValidator().Validate(manifest, Path.Combine(root, "database", "migrations"));
        Assert.DoesNotContain(errors, e => e.Contains("0035", StringComparison.OrdinalIgnoreCase));
    }
}
