using IntegraRP.Application.Abstractions.Services;
using IntegraRP.Infrastructure.Services;
using Xunit;

namespace IntegraRP.Tests;

public sealed class Sprint11HardeningTests
{
    [Fact]
    public void DataMasking_Deve_Mascarar_Dados_Lgpd()
    {
        IDataMaskingService service = new DataMaskingService();

        Assert.Equal("***.***.***-00", service.MaskCpf("123.456.789-00"));
        Assert.Equal("**.***.***/****-99", service.MaskCnpj("12.345.678/0001-99"));
        Assert.Equal("u***@example.com", service.MaskEmail("user@example.com"));
        Assert.Equal("(**) *****-9999", service.MaskPhone("(11) 98888-9999"));
        Assert.Equal("R$ ***", service.MaskFinancial("R$ 10.000,00"));
        Assert.Equal("***", service.MaskDynamicField("valor sensível", sensitiveLgpd: true));
    }

    [Fact]
    public async Task LgpdAudit_Deve_Registrar_Acesso_Sensivel_Por_Tenant()
    {
        ILgpdAuditService service = new InMemoryLgpdAuditService();
        var tenantId = Guid.NewGuid();

        await service.RegisterSensitiveAccessAsync(
            new LgpdAccessLog(
                tenantId,
                Guid.NewGuid(),
                "cliente",
                "documento",
                "visualizacao_autorizada",
                "corr-1",
                DateTimeOffset.UtcNow),
            CancellationToken.None);

        Assert.Single(service.GetRecentAccesses(tenantId));
        Assert.Empty(service.GetRecentAccesses(Guid.NewGuid()));
    }

    [Fact]
    public void Migration0011_Deve_Usar_Apenas_Schema_Integrarp_E_Indices_Criticos()
    {
        var root = Path.Combine("..", "..", "..", "..");
        var sql = File.ReadAllText(Path.Combine(root, "database", "migrations", "0011_hardening_indexes_observability.sql"));

        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.lgpd_log_acesso_dado", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("tenant_id", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("criado_em", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("status", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Api_Deve_Expor_Health_Checks_Padronizados()
    {
        var program = File.ReadAllText(Path.Combine("..", "..", "..", "..", "src", "IntegraRP.Api", "Program.cs"));
        var controller = File.ReadAllText(Path.Combine("..", "..", "..", "..", "src", "IntegraRP.Api", "Controllers", "HealthController.cs"));

        Assert.Contains("RequestLoggingMiddleware", program);
        Assert.Contains("/api/health/live", program);
        Assert.Contains("/api/health/ready", program);
        Assert.Contains("Route(\"api/health\")", controller);
        Assert.Contains("HttpGet(\"live\")", controller);
        Assert.Contains("HttpGet(\"ready\")", controller);
    }
}
