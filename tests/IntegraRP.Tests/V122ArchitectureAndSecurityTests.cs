using Xunit;

namespace IntegraRP.Tests;

public sealed class V122ArchitectureAndSecurityTests
{
    private static readonly string Root = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", ".."));

    [Fact]
    public void Domain_Nao_Deve_Referenciar_Application_Infra_Api_Web_Npgsql_Dapper_AspNet()
    {
        var refs = typeof(IntegraRP.Domain.Tenancy.Tenant).Assembly.GetReferencedAssemblies().Select(x => x.Name).ToArray();
        Assert.DoesNotContain("IntegraRP.Application", refs);
        Assert.DoesNotContain("IntegraRP.Infrastructure", refs);
        Assert.DoesNotContain("IntegraRP.Api", refs);
        Assert.DoesNotContain("IntegraRP.Web", refs);
        Assert.DoesNotContain("Dapper", refs);
        Assert.DoesNotContain("Npgsql", refs);
        Assert.DoesNotContain(refs, name => name is not null && name.StartsWith("Microsoft.AspNetCore", StringComparison.Ordinal));
    }

    [Fact]
    public void Application_Nao_Deve_Referenciar_Runtime_Externo()
    {
        var refs = typeof(IntegraRP.Application.Auth.LoginUseCase).Assembly.GetReferencedAssemblies().Select(x => x.Name).ToArray();
        Assert.DoesNotContain("IntegraRP.Infrastructure", refs);
        Assert.DoesNotContain("IntegraRP.Api", refs);
        Assert.DoesNotContain("IntegraRP.Web", refs);
        Assert.DoesNotContain("Npgsql", refs);
    }

    [Fact]
    public void Controllers_Api_Nao_Devem_Conter_Sql_Dapper_Ou_Npgsql()
    {
        foreach (var file in Directory.EnumerateFiles(Path.Combine(Root, "src", "IntegraRP.Api", "Controllers"), "*Controller*.cs", SearchOption.AllDirectories))
        {
            var text = File.ReadAllText(file);
            Assert.DoesNotContain("Npgsql", text, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("Dapper", text, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("SELECT ", text, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("UPDATE ", text, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("INSERT ", text, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("DELETE ", text, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Web_Nao_Deve_Acessar_PostgreSql_Diretamente()
    {
        foreach (var file in Directory.EnumerateFiles(Path.Combine(Root, "src", "IntegraRP.Web"), "*.cs", SearchOption.AllDirectories))
        {
            var text = File.ReadAllText(file);
            Assert.DoesNotContain("Npgsql", text, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("Dapper", text, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("Host=", text, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void AuthRepository_Nao_Deve_Usar_Curinga_Vazio_Para_FindUser()
    {
        var text = File.ReadAllText(Path.Combine(Root, "src", "IntegraRP.Infrastructure", "Auth", "PostgresAuthenticationRepository.cs"));
        Assert.DoesNotContain("@slug=''", text, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("@email=''", text, StringComparison.OrdinalIgnoreCase);
    }
}
