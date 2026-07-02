using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/processos")]public sealed class ProcessosController(ILogger<ProcessosController> logger, IIntegraRpQueries queries):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet]public async Task<IActionResult> Get(CancellationToken ct){try{logger.LogInformation("Executando ProcessosController");return FromResult(await queries.ProcessosAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em ProcessosController");throw;}}
[HttpGet("templates")]public async Task<IActionResult> Templates(CancellationToken ct){try{logger.LogInformation("Executando ProcessosController");return FromResult(await queries.TemplatesAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em ProcessosController");throw;}}
}
