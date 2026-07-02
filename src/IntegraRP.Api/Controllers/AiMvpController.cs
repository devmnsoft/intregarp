using IntegraRP.Application.Abstractions.Ai;
using IntegraRP.Contracts.Ai;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/ai")]
public sealed class AiMvpController(IAiConversationRepositoryV2 conversations, IAiOrchestratorV2 orchestrator, IAiToolRegistryV2 tools, IAiFeedbackService feedback, ILogger<AiMvpController> logger) : IntegraControllerBase
{
    [HttpPost("conversations")]
    public async Task<IActionResult> Start([FromBody] StartAiConversationRequest request, CancellationToken ct) { try { return Ok(new { id = await conversations.StartAsync(TenantId, Guid.NewGuid(), request, ct) }); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Start)); } }
    [HttpGet("conversations")]
    public async Task<IActionResult> List([FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken ct = default) { try { return Ok(await conversations.ListAsync(TenantId, Guid.NewGuid(), page, pageSize, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("conversations/{id:guid}")]
    public IActionResult Get(Guid id) => Ok(new AiConversationResponse(id, "web", "Conversa IA", "aberta", DateTimeOffset.UtcNow, []));
    [HttpPost("conversations/{id:guid}/messages")]
    public async Task<IActionResult> Send(Guid id, [FromBody] SendAiMessageRequest request, CancellationToken ct) { try { return Ok(await orchestrator.SendAsync(TenantId, Guid.NewGuid(), id, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Send)); } }
    [HttpGet("tools")]
    public IActionResult Tools() => Ok(tools.Tools.Select(t => new IntegraRP.Contracts.Ai.AiToolResponse(t.Code, t.Description, t.Description, "ai", t.RequiredPermission, true)));
    [HttpGet("audit")]
    public IActionResult Audit() => Ok(Array.Empty<AiAuditResponse>());
    [HttpGet("audit/{id:guid}")]
    public IActionResult AuditDetail(Guid id) => Ok(new AiAuditDetailResponse(id, "pergunta mascarada", "resposta", "pedido_status", "get_order_status", true, true, true, "{}", "permitido", null, DateTimeOffset.UtcNow));
    [HttpGet("escalations")]
    public IActionResult Escalations() => Ok(Array.Empty<AiHumanEscalationResponse>());
    [HttpPost("escalations/{id:guid}/resolve")]
    public IActionResult Resolve(Guid id, [FromBody] ResolveAiHumanEscalationRequest request) => Ok();
    [HttpPost("feedback")]
    public async Task<IActionResult> Feedback([FromBody] AddAiUserFeedbackRequest request, CancellationToken ct) => Ok(await feedback.AddAsync(TenantId, Guid.NewGuid(), request, ct));
}
