using IntegraRP.Application.Abstractions.Billing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Billing;

[ApiController]
[Authorize]
[Route("api/billing/dashboard")]
public sealed class BillingDashboardController(IBillingService billingService) : IntegraControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken) => Ok(await billingService.GetDashboardAsync(TenantId, cancellationToken));
}
