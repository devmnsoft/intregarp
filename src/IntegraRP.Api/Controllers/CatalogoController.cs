using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/catalogo")]public sealed class CatalogoController(ILogger<CatalogoController> logger, IIntegraRpQueries queries):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet("modulos")]public async Task<IActionResult> Modulos(CancellationToken ct){try{logger.LogInformation("Executando CatalogoController");return FromResult(await queries.ModulosAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em CatalogoController");throw;}}
}
