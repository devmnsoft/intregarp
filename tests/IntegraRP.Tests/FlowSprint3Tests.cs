using IntegraRP.Domain.Flow;
using Xunit;

namespace IntegraRP.Tests;

public sealed class FlowSprint3Tests
{
    [Fact]
    public void Migration_0003_Deve_Criar_Tabelas_E_Views_Flow()
    {
        var path = Path.Combine("..", "..", "..", "..", "database", "migrations", "0003_flow_bpmn_core.sql");
        var sql = File.ReadAllText(path);
        Assert.Contains("integrarp.processo_definicao", sql);
        Assert.Contains("integrarp.processo_versao", sql);
        Assert.Contains("integrarp.processo_elemento", sql);
        Assert.Contains("integrarp.processo_transicao", sql);
        Assert.Contains("integrarp.processo_instancia", sql);
        Assert.Contains("integrarp.processo_variavel", sql);
        Assert.Contains("integrarp.tarefa", sql);
        Assert.Contains("integrarp.evento_negocio", sql);
        Assert.Contains("integrarp.outbox_evento", sql);
        Assert.Contains("integrarp.vw_flow_dashboard_resumo", sql);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Versao_Publicada_Deve_Exigir_Start_E_End()
    {
        var version = new ProcessVersion { TenantId = Guid.NewGuid(), ProcessDefinitionId = Guid.NewGuid() };
        Assert.Throws<InvalidOperationException>(() => version.Publish());
    }

    [Fact]
    public void HumanTask_Deve_Exigir_Responsavel()
    {
        var element = new ProcessElement { TenantId = Guid.NewGuid(), ProcessVersionId = Guid.NewGuid(), Type = ProcessElementType.HumanTask };
        Assert.Throws<InvalidOperationException>(() => element.Validate());
    }

    [Fact]
    public void Tarefa_Concluida_Nao_Deve_Concluir_Novamente()
    {
        var task = new WorkflowTask { TenantId = Guid.NewGuid() };
        task.Complete(Guid.NewGuid());
        Assert.Throws<InvalidOperationException>(() => task.Complete(Guid.NewGuid()));
    }
}
