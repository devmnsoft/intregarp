using IntegraRP.Application.Ai;
using IntegraRP.Application.Common;
using IntegraRP.Contracts.Requests;
using IntegraRP.Infrastructure.Data.Migrations;
using IntegraRP.Infrastructure.Services;
using Microsoft.Extensions.Logging.Abstractions;
using Xunit;

namespace IntegraRP.Tests;

public sealed class ArchitectureTests
{
    [Fact]
    public void Domain_Nao_Deve_Referenciar_Camadas_Externas()
    {
        var refs = typeof(IntegraRP.Domain.Tenancy.Tenant).Assembly.GetReferencedAssemblies().Select(x => x.Name).ToArray();
        Assert.DoesNotContain("IntegraRP.Infrastructure", refs);
        Assert.DoesNotContain("IntegraRP.Api", refs);
        Assert.DoesNotContain("IntegraRP.Web", refs);
        Assert.DoesNotContain("Dapper", refs);
        Assert.DoesNotContain("Npgsql", refs);
    }

    [Fact]
    public void Sql_Deve_Usar_Apenas_Schema_Integrarp()
    {
        var sql = File.ReadAllText(Path.Combine("..", "..", "..", "..", "database", "migrations", "0001_initial_integrarp.sql"));
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void MigrationScript_Deve_Calcular_Checksum_Estavel()
    {
        var checksum = MigrationScript.CalculateChecksum("select 1;");
        Assert.Equal(checksum, MigrationScript.CalculateChecksum("select 1;"));
    }

    [Fact]
    public void Result_Deve_Representar_Sucesso_E_Falha()
    {
        Assert.True(Result<string>.Success("ok").IsSuccess);
        Assert.False(Result<string>.Failure("erro").IsSuccess);
    }

    [Fact]
    public async Task Studio_Deve_Sugerir_Controle_De_Avarias()
    {
        var service = new InMemoryStudioServices(NullLogger<InMemoryStudioServices>.Instance);
        var draft = await service.SuggestAsync(Guid.NewGuid(), new SmartModuleDraftRequest("controle de avaria"), CancellationToken.None);
        Assert.Equal("Controle de Avarias", draft.Nome);
        Assert.Contains(draft.Campos, campo => campo.Codigo == "produto");
    }

    [Fact]
    public void Ia_Deve_Negar_Ferramenta_Sem_Permissao()
    {
        IAiPermissionValidator validator = new AiPermissionValidator();
        Assert.False(validator.CanUseTool([], "order-status"));
    }
}
