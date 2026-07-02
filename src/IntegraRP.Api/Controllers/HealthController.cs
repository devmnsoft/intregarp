using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/health")]public sealed class HealthController(ILogger<HealthController> logger):ControllerBase{
[HttpGet]public async Task<IActionResult> Get(CancellationToken ct){try{logger.LogInformation("Executando HealthController");return Ok(new { status="Healthy", product="IntegraRP" });}catch(Exception ex){logger.LogError(ex,"Erro em HealthController");throw;}}
}
