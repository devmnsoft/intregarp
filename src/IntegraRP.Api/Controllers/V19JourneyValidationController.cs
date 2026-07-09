using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/validation")]
public sealed class V19ValidationController : ControllerBase
{
    [HttpGet("e2e/customer-to-billing")]
    public IActionResult CustomerToBilling() => Ok(new { status="ok", etapa="dashboard", proximaAcao="Processar outbox", checks=DemoData.Steps });

    [HttpGet("worker/status")]
    public IActionResult WorkerStatus() => Ok(new { status="ok", fila="integrarp.outbox_evento", pendentes=1, processados=1, erros=1, checkpoint=DateTimeOffset.UtcNow });
}
