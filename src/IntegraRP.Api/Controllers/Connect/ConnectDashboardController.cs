using IntegraRP.Application.Abstractions.Connect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Connect;

[ApiController]
[Authorize]
[Route("api/connect/dashboard")]
public sealed class ConnectDashboardController(IConnectService connectService) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> Get(CancellationToken cancellationToken) => Ok(await connectService.GetDashboardAsync(TenantId, cancellationToken));
}
