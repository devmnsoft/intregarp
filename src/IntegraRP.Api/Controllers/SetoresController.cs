using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;using IntegraRP.Contracts.Requests;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/setores")]public sealed class SetoresController(ILogger<SetoresController> logger, IIntegraRpQueries queries):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet]public async Task<IActionResult> Get(CancellationToken ct){try{logger.LogInformation("Executando SetoresController");return FromResult(await queries.SetoresAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em SetoresController");throw;}}
[HttpPost]public async Task<IActionResult> Post([FromBody] CriarSetorRequest request,CancellationToken ct){try{logger.LogInformation("Executando SetoresController");return FromResult(await queries.CriarSetorAsync(request,ct));}catch(Exception ex){logger.LogError(ex,"Erro em SetoresController");throw;}}
}
