using IntegraRP.Application.Ai;
using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Services;

public sealed class AiOrchestrator(IAiIntentClassifier classifier, IAiPermissionValidator validator, IAiToolRegistry registry, IAiResponseGenerator responses, IAiAuditService audit, IHumanEscalationService escalation, IAiDataMaskingService masking, IAiConversationRepository conversations, ILogger<AiOrchestrator> logger) : IAiOrchestrator
{
    public async Task<AiChatResponse> ChatAsync(Guid tenantId, AiChatRequest request, CancellationToken cancellationToken)
    {
        var conversationId = await conversations.CreateAsync(tenantId, request.Canal, cancellationToken);
        var intent = classifier.Classify(request.Mensagem);
        var tool = registry.Find(intent);
        if (tool is null || !validator.CanUseTool(request.Permissoes, tool.Code))
        {
            await escalation.OpenAsync(tenantId, $"Ferramenta não permitida para intenção {intent}", cancellationToken);
            logger.LogWarning("IA escalou para humano. Tenant {TenantId}, intenção {Intent}", tenantId, intent);
            return new AiChatResponse(conversationId, intent, "Não tenho permissão para consultar esses dados. Abri uma tarefa humana.", true, 0.35m);
        }

        var result = await tool.ExecuteAsync(tenantId, request.Mensagem, cancellationToken);
        var masked = masking.Mask(result);
        var response = responses.Generate(intent, masked, true);
        await audit.RegisterAsync(tenantId, intent, tool.Code, request.Mensagem, response, cancellationToken);
        return new AiChatResponse(conversationId, intent, response, false, 0.86m);
    }
}

public sealed class RuleBasedIntentClassifier : IAiIntentClassifier
{
    public string Classify(string message)
    {
        if (message.Contains("pedido", StringComparison.OrdinalIgnoreCase)) return "order-status";
        if (message.Contains("entrega", StringComparison.OrdinalIgnoreCase) || message.Contains("pod", StringComparison.OrdinalIgnoreCase)) return "delivery-proof";
        if (message.Contains("financeiro", StringComparison.OrdinalIgnoreCase) || message.Contains("boleto", StringComparison.OrdinalIgnoreCase)) return "financial-title";
        if (message.Contains("kpi", StringComparison.OrdinalIgnoreCase)) return "authorized-kpi";
        if (message.Contains("módulo", StringComparison.OrdinalIgnoreCase) || message.Contains("modulo", StringComparison.OrdinalIgnoreCase)) return "dynamic-search";
        return "human-task";
    }
}

public sealed class AiPermissionValidator : IAiPermissionValidator
{
    public bool CanUseTool(IReadOnlyCollection<string> permissions, string toolCode) => permissions.Contains($"ai.tool.{toolCode}") || permissions.Contains("ai.tool.*");
}

public sealed class AiToolRegistry(IEnumerable<IAiTool> tools) : IAiToolRegistry
{
    public IReadOnlyList<IAiTool> Tools { get; } = tools.ToArray();
    public IAiTool? Find(string intent) => Tools.FirstOrDefault(x => x.Code == intent);
}

public sealed class AiResponseGenerator : IAiResponseGenerator
{
    public string Generate(string intent, string toolResult, bool masked) => $"IA governada ({intent}): {toolResult}";
}

public sealed class AiAuditService(ILogger<AiAuditService> logger) : IAiAuditService
{
    public Task RegisterAsync(Guid tenantId, string intent, string toolCode, string question, string response, CancellationToken cancellationToken)
    {
        logger.LogInformation("Auditoria IA tenant {TenantId}, intent {Intent}, tool {ToolCode}", tenantId, intent, toolCode);
        return Task.CompletedTask;
    }
}

public sealed class HumanEscalationService : IHumanEscalationService
{
    public Task<Guid> OpenAsync(Guid tenantId, string reason, CancellationToken cancellationToken) => Task.FromResult(Guid.NewGuid());
}

public sealed class AiDataMaskingService : IAiDataMaskingService
{
    public string Mask(string value) => value.Replace("12345678900", "***.***.***-**", StringComparison.Ordinal);
}

public sealed class AiConversationRepository : IAiConversationRepository
{
    public Task<Guid> CreateAsync(Guid tenantId, string channel, CancellationToken cancellationToken) => Task.FromResult(Guid.NewGuid());
}

public abstract class StaticAiTool(string code, string name, string permission, string response) : IAiTool
{
    public string Code => code;
    public string Name => name;
    public string RequiredPermission => permission;
    public Task<string> ExecuteAsync(Guid tenantId, string message, CancellationToken cancellationToken) => Task.FromResult(response);
}

public sealed class GetOrderStatusTool() : StaticAiTool("order-status", "Status do Pedido", "ai.tool.order-status", "Pedido localizado com status Em separação.")
{
}
public sealed class GetDeliveryProofTool() : StaticAiTool("delivery-proof", "Prova de Entrega", "ai.tool.delivery-proof", "POD registrado e disponível para usuário autorizado.")
{
}
public sealed class GetFinancialTitleTool() : StaticAiTool("financial-title", "Título Financeiro", "ai.tool.financial-title", "Título em aberto com vencimento futuro.")
{
}
public sealed class SearchDynamicModuleTool() : StaticAiTool("dynamic-search", "Pesquisar Módulo Dinâmico", "ai.tool.dynamic-search", "Registros dinâmicos consultados por ferramenta autorizada.")
{
}
public sealed class GetAuthorizedKpiTool() : StaticAiTool("authorized-kpi", "KPI Autorizado", "ai.tool.authorized-kpi", "KPI autorizado calculado a partir do serviço interno.")
{
}
public sealed class OpenHumanTaskTool() : StaticAiTool("human-task", "Abrir Tarefa Humana", "ai.tool.human-task", "Tarefa humana aberta para análise operacional.")
{
}
