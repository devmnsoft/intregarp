using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;using IntegraRP.Contracts.Requests;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/tarefas")]public sealed class TarefasController(ILogger<TarefasController> logger, IIntegraRpQueries queries):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet]public async Task<IActionResult> Get(CancellationToken ct){try{logger.LogInformation("Executando TarefasController");return FromResult(await queries.TarefasAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em TarefasController");throw;}}
[HttpPost]public async Task<IActionResult> Post([FromBody] CriarTarefaRequest request,CancellationToken ct){try{logger.LogInformation("Executando TarefasController");return FromResult(await queries.CriarTarefaAsync(request,ct));}catch(Exception ex){logger.LogError(ex,"Erro em TarefasController");throw;}}
[HttpPatch("{id:guid}/concluir")]public async Task<IActionResult> Concluir(Guid id,CancellationToken ct){try{logger.LogInformation("Executando TarefasController");return FromResult(await queries.ConcluirTarefaAsync(id,ct));}catch(Exception ex){logger.LogError(ex,"Erro em TarefasController");throw;}}
}
