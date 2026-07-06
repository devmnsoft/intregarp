using IntegraRP.Application.Operations;
using IntegraRP.Contracts.Operations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/operations/routes")]
public sealed class DeliveryRoutesController(ListDeliveryRoutesUseCase list, GetDeliveryRouteByIdUseCase get, CreateDeliveryRouteUseCase create, UpdateDeliveryRouteUseCase update, AddDeliveryRouteStopUseCase addStop, ReorderDeliveryRouteStopsUseCase reorder, StartDeliveryRouteUseCase start, CompleteDeliveryRouteUseCase complete, CancelDeliveryRouteUseCase cancel, ILogger<DeliveryRoutesController> logger) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) { try { return Ok((await list.ExecuteAsync(TenantId, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) { try { var r = await get.ExecuteAsync(TenantId, id, ct); return r.Value is null ? NotFound() : Ok(r.Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } }
    [HttpPost] public async Task<IActionResult> Create([FromBody] CreateDeliveryRouteRequest request, CancellationToken ct) { try { return Ok((await create.ExecuteAsync(request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Create)); } }
    [HttpPut("{id:guid}")] public async Task<IActionResult> Update(Guid id, [FromBody] UpdateDeliveryRouteRequest request, CancellationToken ct) { try { return Ok((await update.ExecuteAsync(TenantId, id, request, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Update)); } }
    [HttpPost("{id:guid}/stops")] public async Task<IActionResult> AddStop(Guid id, [FromBody] AddDeliveryRouteStopRequest request, CancellationToken ct) { try { return Ok((await addStop.ExecuteAsync(id, request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(AddStop)); } }
    [HttpPost("{id:guid}/stops/reorder")] public async Task<IActionResult> Reorder(Guid id, [FromBody] ReorderDeliveryRouteStopsRequest request, CancellationToken ct) { try { return Ok((await reorder.ExecuteAsync(id, request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Reorder)); } }
    [HttpPost("{id:guid}/start")] public async Task<IActionResult> Start(Guid id, CancellationToken ct) { try { return Ok((await start.ExecuteAsync(TenantId, id, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Start)); } }
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, CancellationToken ct) { try { return Ok((await complete.ExecuteAsync(TenantId, id, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Complete)); } }
    [HttpPost("{id:guid}/cancel")] public async Task<IActionResult> Cancel(Guid id, CancellationToken ct) { try { return Ok((await cancel.ExecuteAsync(TenantId, id, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Cancel)); } }
}
