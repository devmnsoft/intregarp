using IntegraRP.Application.Operations;
using IntegraRP.Contracts.Operations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/operations/manifests")]
public sealed class DeliveryManifestsController(ListDeliveryManifestsUseCase list, GetDeliveryManifestByIdUseCase get, CreateDeliveryManifestUseCase create, AddDeliveryManifestItemUseCase addItem, ConfirmDeliveryManifestUseCase confirm, StartManifestRouteUseCase start, CompleteDeliveryManifestUseCase complete, ILogger<DeliveryManifestsController> logger) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) { try { return Ok((await list.ExecuteAsync(TenantId, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) { try { var r = await get.ExecuteAsync(TenantId, id, ct); return r.Value is null ? NotFound() : Ok(r.Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } }
    [HttpPost] public async Task<IActionResult> Create([FromBody] CreateDeliveryManifestRequest request, CancellationToken ct) { try { return Ok((await create.ExecuteAsync(request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Create)); } }
    [HttpPost("{id:guid}/items")] public async Task<IActionResult> AddItem(Guid id, [FromBody] AddDeliveryManifestItemRequest request, CancellationToken ct) { try { return Ok((await addItem.ExecuteAsync(id, request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(AddItem)); } }
    [HttpPost("{id:guid}/confirm")] public async Task<IActionResult> Confirm(Guid id, CancellationToken ct) { try { return Ok((await confirm.ExecuteAsync(TenantId, id, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Confirm)); } }
    [HttpPost("{id:guid}/start-route")] public async Task<IActionResult> StartRoute(Guid id, CancellationToken ct) { try { return Ok((await start.ExecuteAsync(TenantId, id, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(StartRoute)); } }
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, CancellationToken ct) { try { return Ok((await complete.ExecuteAsync(TenantId, id, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Complete)); } }
}
