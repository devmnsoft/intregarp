using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/integrations")]
public sealed class IntegrationsController : IntegraControllerBase
{
    [HttpGet("connectors")]
    public IActionResult GetConnectors(CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpPost("connectors")]
    public IActionResult CreateConnector(CancellationToken ct) => Ok();

    [HttpPut("connectors/{id:guid}")]
    public IActionResult UpdateConnector(Guid id, CancellationToken ct) => Ok();

    [HttpPost("connectors/{id:guid}/test")]
    public IActionResult TestConnector(Guid id, CancellationToken ct) => Ok(new { status = "sandbox" });

    [HttpGet("executions")]
    public IActionResult Executions(CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpPost("webhooks/{code}")]
    public IActionResult Webhook(string code, CancellationToken ct) => Ok();

    [HttpPost("queue/process")]
    public IActionResult Process(CancellationToken ct) => Ok();
}

[Authorize]
[ApiController]
[Route("api/fiscal")]
public sealed class FiscalController : IntegraControllerBase
{
    [HttpGet("documents")]
    public IActionResult List(CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpGet("documents/{id:guid}")]
    public IActionResult Get(Guid id, CancellationToken ct) => Ok(new { id });

    [HttpPost("documents/from-invoice/{invoiceId:guid}")]
    public IActionResult FromInvoice(Guid invoiceId, CancellationToken ct) => Ok();

    [HttpPost("documents/{id:guid}/validate")]
    public IActionResult Validate(Guid id, CancellationToken ct) => Ok();

    [HttpPost("documents/{id:guid}/emit-fake")]
    public IActionResult Emit(Guid id, CancellationToken ct) => Ok(new { status = "emitida_fake" });

    [HttpPost("documents/{id:guid}/cancel")]
    public IActionResult Cancel(Guid id, CancellationToken ct) => Ok();

    [HttpGet("documents/{id:guid}/danfe-html")]
    public IActionResult Danfe(Guid id, CancellationToken ct) => Content("<html><body>DANFE HTML fake</body></html>", "text/html");
}

[Authorize]
[ApiController]
[Route("api/reconciliation")]
public sealed class ReconciliationController : IntegraControllerBase
{
    [HttpGet("bank-accounts")]
    public IActionResult Accounts(CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpPost("bank-accounts")]
    public IActionResult CreateAccount(CancellationToken ct) => Ok();

    [HttpPost("statements/import")]
    public IActionResult Import(CancellationToken ct) => Ok();

    [HttpGet("statements/{importId:guid}/entries")]
    public IActionResult Entries(Guid importId, CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpPost("suggest")]
    public IActionResult Suggest(CancellationToken ct) => Ok();

    [HttpPost("{id:guid}/confirm")]
    public IActionResult Confirm(Guid id, CancellationToken ct) => Ok();

    [HttpPost("{id:guid}/reject")]
    public IActionResult Reject(Guid id, CancellationToken ct) => Ok();

    [HttpGet("receivables/projection")]
    public IActionResult Projection(CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpGet("delinquency-alerts")]
    public IActionResult Alerts(CancellationToken ct) => Ok(Array.Empty<object>());
}

[Authorize]
[ApiController]
[Route("api/routing")]
public sealed class RouteOptimizationController : IntegraControllerBase
{
    [HttpPost("routes/{routeId:guid}/optimize")]
    public IActionResult Optimize(Guid routeId, CancellationToken ct) => Ok();

    [HttpGet("optimizations")]
    public IActionResult List(CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpGet("optimizations/{id:guid}")]
    public IActionResult Get(Guid id, CancellationToken ct) => Ok(new { id });

    [HttpPost("optimizations/{id:guid}/apply")]
    public IActionResult Apply(Guid id, CancellationToken ct) => Ok();

    [HttpPost("optimizations/{id:guid}/stops/reorder")]
    public IActionResult Reorder(Guid id, CancellationToken ct) => Ok();

    [HttpGet("routes/{routeId:guid}/distance")]
    public IActionResult Distance(Guid routeId, CancellationToken ct) => Ok(new { distanceKm = 0 });
}

[Authorize]
[ApiController]
[Route("api/offline")]
public sealed class OfflineSyncController : IntegraControllerBase
{
    [HttpPost("devices/register")]
    public IActionResult Register(CancellationToken ct) => Ok();

    [HttpPost("packages")]
    public IActionResult Package(CancellationToken ct) => Ok();

    [HttpGet("packages/{id:guid}")]
    public IActionResult GetPackage(Guid id, CancellationToken ct) => Ok(new { id });

    [HttpPost("sync")]
    public IActionResult Sync(CancellationToken ct) => Ok();

    [HttpGet("conflicts")]
    public IActionResult Conflicts(CancellationToken ct) => Ok(Array.Empty<object>());

    [HttpPost("conflicts/{id:guid}/resolve")]
    public IActionResult Resolve(Guid id, CancellationToken ct) => Ok();

    [HttpGet("status")]
    public IActionResult Status(CancellationToken ct) => Ok(new { status = "offline-ready" });
}
