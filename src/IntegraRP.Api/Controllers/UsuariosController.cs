using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/usuarios")]public sealed class UsuariosController(ILogger<UsuariosController> logger, IIntegraRpQueries queries):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet]public async Task<IActionResult> Get(CancellationToken ct){try{logger.LogInformation("Executando UsuariosController");return FromResult(await queries.UsuariosAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em UsuariosController");throw;}}
}
