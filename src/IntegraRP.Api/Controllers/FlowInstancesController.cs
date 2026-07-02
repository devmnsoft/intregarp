using IntegraRP.Application.Abstractions.Flow;
using IntegraRP.Contracts.Flow;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Tags("Flow Instances")]
public sealed class FlowInstancesController(IProcessInstanceRepository instances, IWorkflowEngine engine, IWorkflowAuditRepository audit, ILogger<FlowInstancesController> logger) : IntegraControllerBase
{
    [HttpGet("api/flow/instances")]
    public async Task<IActionResult> List(CancellationToken ct) { try { return Ok(await instances.ListAsync(TenantId, null, 1, 50, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("api/flow/instances/{id:guid}")]
    public async Task<IActionResult> Get(Guid id, CancellationToken ct) { try { return Ok(await instances.GetAsync(TenantId, id, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } }
    [HttpPost("api/flow/definitions/{definitionId:guid}/start")]
    public async Task<IActionResult> Start(Guid definitionId, [FromBody] StartProcessInstanceRequest request, CancellationToken ct) { try { return Ok(await engine.StartProcessInstanceAsync(TenantId, definitionId, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Start)); } }
    [HttpPost("api/flow/instances/{id:guid}/cancel")]
    public async Task<IActionResult> Cancel(Guid id, [FromBody] CancelProcessInstanceRequest request, CancellationToken ct) { try { await instances.CancelAsync(TenantId, id, request.Motivo, ct); return NoContent(); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Cancel)); } }
    [HttpGet("api/flow/instances/{id:guid}/audit")]
    public async Task<IActionResult> Audit(Guid id, CancellationToken ct) { try { return Ok(await audit.ListByInstanceAsync(TenantId, id, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Audit)); } }
}
