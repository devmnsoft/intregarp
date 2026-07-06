using IntegraRP.Application.Operations;
using IntegraRP.Contracts.Operations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/operations/deliveries")]
public sealed class DeliveryMonitoringController(GetDeliveryMonitoringDashboardUseCase dashboard, ListPendingDeliveriesUseCase pending, ListDeliveriesWithOccurrenceUseCase occurrences, RegisterProofOfDeliveryUseCase pod, RegisterDeliveryOccurrenceUseCase registerOccurrence, ResolveDeliveryOccurrenceUseCase resolve, ILogger<DeliveryMonitoringController> logger) : IntegraControllerBase
{
    [HttpGet("dashboard")] public async Task<IActionResult> Dashboard(CancellationToken ct) { try { return Ok((await dashboard.ExecuteAsync(TenantId, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Dashboard)); } }
    [HttpGet("pending")] public async Task<IActionResult> Pending(CancellationToken ct) { try { return Ok((await pending.ExecuteAsync(TenantId, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Pending)); } }
    [HttpGet("occurrences")] public async Task<IActionResult> Occurrences(CancellationToken ct) { try { return Ok((await occurrences.ExecuteAsync(TenantId, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Occurrences)); } }
    [HttpPost("pod")] public async Task<IActionResult> Pod([FromBody] RegisterProofOfDeliveryRequest request, CancellationToken ct) { try { return Ok((await pod.ExecuteAsync(request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Pod)); } }
    [HttpPost("occurrences")] public async Task<IActionResult> RegisterOccurrence([FromBody] RegisterDeliveryOccurrenceRequest request, CancellationToken ct) { try { return Ok((await registerOccurrence.ExecuteAsync(request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(RegisterOccurrence)); } }
    [HttpPost("occurrences/{id:guid}/resolve")] public async Task<IActionResult> Resolve(Guid id, [FromBody] ResolveDeliveryOccurrenceRequest request, CancellationToken ct) { try { return Ok((await resolve.ExecuteAsync(TenantId, id, request with { TenantId = TenantId }, ct)).Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Resolve)); } }
}
