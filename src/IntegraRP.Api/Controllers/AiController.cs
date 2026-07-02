using IntegraRP.Application.Ai;
using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/ai")]
public sealed class AiController(IAiOrchestrator orchestrator, IAiToolRegistry tools, ILogger<AiController> logger) : IntegraControllerBase
{
    [HttpPost("chat")]
    public async Task<IActionResult> Chat([FromBody] AiChatRequest request, CancellationToken cancellationToken) { try { return Ok(await orchestrator.ChatAsync(TenantId, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Chat)); } }

    [HttpGet("conversas")]
    public IActionResult Conversations() => Ok(Array.Empty<object>());

    [HttpGet("auditoria")]
    public IActionResult Audit() => Ok(Array.Empty<object>());

    [HttpGet("ferramentas")]
    public IActionResult ToolList() => Ok(tools.Tools.Select(x => new AiToolResponse(x.Code, x.Name, true)));
}
