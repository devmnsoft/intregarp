using Xunit;

namespace IntegraRP.Tests;

public sealed class Sprint10OperationalTemplatesTests
{
    private static readonly string MigrationPath = Path.Combine("..", "..", "..", "..", "database", "migrations", "0010_templates_operacionais_distribuicao_campo.sql");

    [Fact]
    public void Migration_0010_Deve_Existir_E_Usar_Schema_Integrarp()
    {
        Assert.True(File.Exists(MigrationPath));
        var sql = File.ReadAllText(MigrationPath);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.template_operacional_pacote", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Theory]
    [InlineData("template_operacional_pacote")]
    [InlineData("template_operacional")]
    [InlineData("template_operacional_item")]
    [InlineData("template_operacional_instalacao")]
    [InlineData("template_operacional_instalacao_log")]
    [InlineData("template_operacional_dependencia")]
    [InlineData("template_operacional_variavel")]
    [InlineData("template_operacional_kpi")]
    [InlineData("template_operacional_ai_catalogo")]
    [InlineData("template_operacional_mensagem")]
    [InlineData("template_operacional_dashboard")]
    [InlineData("operacao_rota")]
    [InlineData("operacao_rota_parada")]
    [InlineData("operacao_romaneio")]
    [InlineData("operacao_romaneio_item")]
    [InlineData("operacao_entrega_monitoramento")]
    [InlineData("operacao_prova_entrega")]
    [InlineData("operacao_ocorrencia_entrega")]
    public void Migration_Deve_Conter_Tabelas_Obrigatorias(string table)
    {
        var sql = File.ReadAllText(MigrationPath);
        Assert.Contains($"integrarp.{table}", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Theory]
    [InlineData("pacote_operacao_distribuicao")]
    [InlineData("controle_avarias")]
    [InlineData("tratamento_devolucoes")]
    [InlineData("romaneio_entrega")]
    [InlineData("roteirizacao_entregas")]
    [InlineData("visita_promotor")]
    public void Seeds_De_Templates_Obrigatorios_Devem_Existir(string code)
    {
        var sql = File.ReadAllText(MigrationPath);
        Assert.Contains(code, sql, StringComparison.OrdinalIgnoreCase);
    }
}
