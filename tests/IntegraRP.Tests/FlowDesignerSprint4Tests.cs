using IntegraRP.Contracts.FlowDesigner;
using IntegraRP.Infrastructure.Services.FlowDesigner;
using Microsoft.Extensions.Logging.Abstractions;
using Xunit;

namespace IntegraRP.Tests;

public sealed class FlowDesignerSprint4Tests
{
    [Fact]
    public void Migration_0004_Deve_Usar_Schema_Integrarp_E_Criar_Metadata()
    {
        var path = Path.Combine("..", "..", "..", "..", "database", "migrations", "0004_flow_designer_web.sql");
        var sql = File.ReadAllText(path);
        Assert.Contains("integrarp.flow_template", sql);
        Assert.Contains("integrarp.flow_template_elemento", sql);
        Assert.Contains("integrarp.flow_template_transicao", sql);
        Assert.Contains("integrarp.flow_designer_historico", sql);
        Assert.Contains("designer_layout_json", sql);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql);
        Assert.Contains("CREATE OR REPLACE VIEW", sql);
        Assert.Contains("CREATE OR REPLACE FUNCTION", sql);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task Templates_Obrigatorios_Devem_Existir_Com_Start_E_End()
    {
        var service = new InMemoryFlowDesignerServices(NullLogger<InMemoryFlowDesignerServices>.Instance);
        var result = await service.ListAsync(Guid.NewGuid(), null, null, 1, 100, CancellationToken.None);
        var templates = result.Value!;
        Assert.Contains(templates, x => x.Nome == "Pedido ao Pós-venda");
        Assert.Contains(templates, x => x.Nome == "Emissão de Boletos");
        Assert.Contains(templates, x => x.Nome == "Separação de Pedidos");
        Assert.Contains(templates, x => x.Nome == "Recebimento de Notas Fiscais");
        Assert.All(templates, x => Assert.Contains(x.Elements, e => e.Tipo == "start_event"));
        Assert.All(templates, x => Assert.Contains(x.Elements, e => e.Tipo == "end_event"));
        Assert.All(templates, x => Assert.Equal(x.Elements.Count, x.Elements.Select(e => e.Codigo).Distinct(StringComparer.OrdinalIgnoreCase).Count()));
    }

    [Fact]
    public void Validador_Deve_Bloquear_Fluxo_Sem_Start_End_Gateway_Fallback_E_Responsavel()
    {
        var service = new InMemoryFlowDesignerServices(NullLogger<InMemoryFlowDesignerServices>.Instance);
        var human = new FlowDesignerElementResponse(Guid.NewGuid(), "tarefa", "Tarefa", "human_task", null, null, null, null, 10, "{}", "{\"fields\":[]}", "[]", 10, 10);
        var gateway = new FlowDesignerElementResponse(Guid.NewGuid(), "gw", "Gateway", "gateway", null, null, null, null, null, "{}", "{\"fields\":[]}", "[]", 200, 10);
        var version = new FlowDesignerVersionResponse(Guid.NewGuid(), Guid.NewGuid(), "Teste", "rascunho", "{}", [human, gateway], [], null);
        var validation = service.Validate(version);
        Assert.False(validation.CanPublish);
        Assert.Contains(validation.Issues, x => x.Code == "missing_start_event");
        Assert.Contains(validation.Issues, x => x.Code == "missing_end_event");
        Assert.Contains(validation.Issues, x => x.Code == "gateway_without_outputs");
        Assert.Contains(validation.Issues, x => x.Code == "human_task_without_owner");
    }

    [Fact]
    public void Validador_Deve_Bloquear_Select_Sem_Opcoes_E_Obrigatorio_Sem_Label()
    {
        var service = new InMemoryFlowDesignerServices(NullLogger<InMemoryFlowDesignerServices>.Instance);
        var field = new FlowFormFieldDto("status", "", "select", true, null, null, [], null, null, 1, null);
        var issues = service.Validate(new FlowFormSchemaDto([field]), Guid.NewGuid());
        Assert.Contains(issues, x => x.Code == "select_without_options");
        Assert.Contains(issues, x => x.Code == "required_field_without_label");
    }
}
