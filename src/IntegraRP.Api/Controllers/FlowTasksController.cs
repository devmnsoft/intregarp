using IntegraRP.Application.Abstractions.Flow;
using IntegraRP.Contracts.Flow;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/flow/tasks")]
[Tags("Flow Tasks")]
public sealed class FlowTasksController(IWorkflowTaskRepository tasks, IWorkflowEngine engine, ILogger<FlowTasksController> logger) : IntegraControllerBase
{
    [HttpGet]
    public async Task<IActionResult> List(CancellationToken ct) { try { return Ok(await tasks.ListAsync(TenantId, null, null, null, 1, 50, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("{id:guid}")]
    public async Task<IActionResult> Get(Guid id, CancellationToken ct) { try { return Ok(await tasks.GetAsync(TenantId, id, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } }
    [HttpPost("{id:guid}/assume")]
    public async Task<IActionResult> Assume(Guid id, [FromQuery] Guid userId, CancellationToken ct) { try { return Ok(await tasks.AssumeAsync(TenantId, id, userId, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Assume)); } }
    [HttpPost("{id:guid}/assign")]
    public async Task<IActionResult> Assign(Guid id, [FromBody] AssignWorkflowTaskRequest request, CancellationToken ct) { try { return Ok(await tasks.AssignAsync(TenantId, id, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Assign)); } }
    [HttpPost("{id:guid}/complete")]
    public async Task<IActionResult> Complete(Guid id, [FromBody] CompleteWorkflowTaskRequest request, CancellationToken ct) { try { return Ok(await engine.CompleteWorkflowTaskAsync(TenantId, id, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Complete)); } }
    [HttpPost("{id:guid}/cancel")]
    public async Task<IActionResult> Cancel(Guid id, [FromQuery] Guid? userId, CancellationToken ct) { try { return Ok(await tasks.CancelAsync(TenantId, id, userId, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Cancel)); } }
    [HttpPost("{id:guid}/comments")]
    public async Task<IActionResult> Comment(Guid id, [FromBody] AddWorkflowTaskCommentRequest request, CancellationToken ct) { try { await tasks.AddCommentAsync(TenantId, id, request, ct); return NoContent(); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Comment)); } }
    [HttpPost("{id:guid}/attachments")]
    public async Task<IActionResult> Attachment(Guid id, [FromBody] AddWorkflowTaskAttachmentRequest request, CancellationToken ct) { try { await tasks.AddAttachmentAsync(TenantId, id, request, ct); return NoContent(); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Attachment)); } }
}
