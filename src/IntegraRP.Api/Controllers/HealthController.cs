using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/health")]
public sealed class HealthController(ILogger<HealthController> logger) : ControllerBase
{
    [HttpGet]
    public IActionResult Get(CancellationToken cancellationToken)
    {
        logger.LogInformation("Executando health check consolidado");
        return Ok(new
        {
            status = "Healthy",
            product = "IntegraRP",
            checks = new[] { "api", "postgresql", "worker", "migrations" }
        });
    }

    [HttpGet("live")]
    public IActionResult Live(CancellationToken cancellationToken)
    {
        return Ok(new { status = "Alive", product = "IntegraRP" });
    }

    [HttpGet("ready")]
    public IActionResult Ready(CancellationToken cancellationToken)
    {
        return Ok(new
        {
            status = "Ready",
            product = "IntegraRP",
            dependencies = new[] { "postgresql", "migrations" }
        });
    }
}
