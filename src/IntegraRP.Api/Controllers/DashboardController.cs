using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/dashboard")]public partial class DashboardController(ILogger<DashboardController> logger, IIntegraRpQueries queries):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet]public IActionResult V19()=>Ok(DemoData.Dashboard);
[HttpGet("resumo")]public async Task<IActionResult> Resumo(CancellationToken ct){try{logger.LogInformation("Executando DashboardController");return FromResult(await queries.DashboardAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em DashboardController");throw;}}
}
