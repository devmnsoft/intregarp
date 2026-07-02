using IntegraRP.Domain.Ai;
using IntegraRP.Domain.Mobile;
using IntegraRP.Infrastructure.Services;
using Xunit;

namespace IntegraRP.Tests;

public sealed class Sprint8MobileAiTests
{
    [Fact]
    public void Migration_0008_Deve_Existir_E_Usar_Apenas_Schema_Integrarp()
    {
        var path = Path.Combine("..", "..", "..", "..", "database", "migrations", "0008_mobile_ai_mvp.sql");
        Assert.True(File.Exists(path));
        var sql = File.ReadAllText(path);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.mobile_dispositivo", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.mobile_execucao_tarefa", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.ai_auditoria", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.ai_escalonamento_humano", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Evidencia_Sem_Vinculo_Falha_Regra_De_Dominio()
    {
        var evidence = new MobileEvidence(Guid.NewGuid(), Guid.NewGuid(), MobileEvidenceType.Foto, null, null, null, null, DateTimeOffset.UtcNow);
        Assert.False(evidence.HasLink);
    }

    [Fact]
    public void Tarefa_Concluida_Nao_Pode_Concluir_Novamente()
    {
        var execution = new MobileTaskExecution(Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), MobileTaskExecutionStatus.Concluida, DateTimeOffset.UtcNow);
        Assert.False(execution.CanComplete);
    }

    [Fact]
    public void Classificador_Identifica_Pedido_Status()
    {
        var classifier = new RuleBasedIntentClassifierV2();
        var result = classifier.Classify("qual status do pedido 123?");
        Assert.Equal("pedido_status", result.IntentCode);
        Assert.Equal("get_order_status", result.ToolCode);
    }

    [Fact]
    public void Classificador_Retorna_Desconhecida_Com_Baixa_Confianca()
    {
        var classifier = new RuleBasedIntentClassifierV2();
        var result = classifier.Classify("pergunta sem contexto seguro");
        Assert.Equal("desconhecida", result.IntentCode);
        Assert.True(result.Confidence < 0.5m);
    }

    [Fact]
    public void PermissionValidator_Nega_Usuario_Sem_Permissao()
    {
        var validator = new AiPermissionValidatorV2();
        Assert.False(validator.HasPermission(Array.Empty<string>(), "ai.tool.order_status"));
    }

    [Fact]
    public void ToolRegistry_Nao_Executa_Tool_Inexistente()
    {
        var registry = new AiToolRegistryV2(Array.Empty<global::IntegraRP.Application.Abstractions.Ai.IAiToolV2>());
        Assert.Null(registry.Find("sql_dinamico"));
    }

    [Fact]
    public void AiConfidence_Classifica_Baixa()
    {
        Assert.Equal(AiConfidenceLevel.Baixa, new AiConfidence(0.2m).Level);
    }
}
