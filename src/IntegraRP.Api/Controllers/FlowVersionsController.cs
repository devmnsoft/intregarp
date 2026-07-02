using IntegraRP.Application.Abstractions.Flow;
using IntegraRP.Contracts.Flow;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Tags("Flow Versions")]
public sealed class FlowVersionsController(IProcessVersionRepository versions, IProcessElementRepository elements, IProcessTransitionRepository transitions, ILogger<FlowVersionsController> logger) : IntegraControllerBase
{
    [HttpPost("api/flow/definitions/{definitionId:guid}/versions")]
    public async Task<IActionResult> Create(Guid definitionId, CancellationToken ct) { try { return Ok(await versions.CreateDraftAsync(TenantId, definitionId, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Create)); } }
    [HttpGet("api/flow/versions/{versionId:guid}")]
    public async Task<IActionResult> Diagram(Guid versionId, CancellationToken ct) { try { return Ok(await versions.GetDiagramAsync(TenantId, versionId, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Diagram)); } }
    [HttpPost("api/flow/versions/{versionId:guid}/elements")]
    public async Task<IActionResult> AddElement(Guid versionId, [FromBody] AddProcessElementRequest request, CancellationToken ct) { try { return Ok(await elements.AddAsync(TenantId, versionId, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(AddElement)); } }
    [HttpPut("api/flow/versions/{versionId:guid}/elements/{elementId:guid}")]
    public async Task<IActionResult> UpdateElement(Guid versionId, Guid elementId, [FromBody] UpdateProcessElementRequest request, CancellationToken ct) { try { return Ok(await elements.UpdateAsync(TenantId, versionId, elementId, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(UpdateElement)); } }
    [HttpDelete("api/flow/versions/{versionId:guid}/elements/{elementId:guid}")]
    public async Task<IActionResult> RemoveElement(Guid versionId, Guid elementId, CancellationToken ct) { try { await elements.RemoveAsync(TenantId, versionId, elementId, ct); return NoContent(); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(RemoveElement)); } }
    [HttpPost("api/flow/versions/{versionId:guid}/transitions")]
    public async Task<IActionResult> AddTransition(Guid versionId, [FromBody] AddProcessTransitionRequest request, CancellationToken ct) { try { return Ok(await transitions.AddAsync(TenantId, versionId, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(AddTransition)); } }
    [HttpPut("api/flow/versions/{versionId:guid}/transitions/{transitionId:guid}")]
    public async Task<IActionResult> UpdateTransition(Guid versionId, Guid transitionId, [FromBody] UpdateProcessTransitionRequest request, CancellationToken ct) { try { return Ok(await transitions.UpdateAsync(TenantId, versionId, transitionId, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(UpdateTransition)); } }
    [HttpDelete("api/flow/versions/{versionId:guid}/transitions/{transitionId:guid}")]
    public async Task<IActionResult> RemoveTransition(Guid versionId, Guid transitionId, CancellationToken ct) { try { await transitions.RemoveAsync(TenantId, versionId, transitionId, ct); return NoContent(); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(RemoveTransition)); } }
    [HttpPost("api/flow/versions/{versionId:guid}/publish")]
    public async Task<IActionResult> Publish(Guid versionId, [FromBody] PublishProcessVersionRequest request, CancellationToken ct) { try { return Ok(await versions.PublishAsync(TenantId, versionId, request.UsuarioId, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Publish)); } }
}
