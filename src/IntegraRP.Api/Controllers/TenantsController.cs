using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;using IntegraRP.Contracts.Requests;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[ApiController][Route("api/tenants")]public sealed class TenantsController(ILogger<TenantsController> logger, IIntegraRpQueries queries):ControllerBase{
IActionResult FromResult<T>(Result<T> r)=>r.IsSuccess?Ok(r.Value):Problem(r.Error,statusCode:400);
[HttpGet]public async Task<IActionResult> Get(CancellationToken ct){try{logger.LogInformation("Executando TenantsController");return FromResult(await queries.TenantsAsync(ct));}catch(Exception ex){logger.LogError(ex,"Erro em TenantsController");throw;}}
[HttpPost]public async Task<IActionResult> Post([FromBody] CriarTenantRequest request,CancellationToken ct){try{logger.LogInformation("Executando TenantsController");return FromResult(await queries.CriarTenantAsync(request,ct));}catch(Exception ex){logger.LogError(ex,"Erro em TenantsController");throw;}}
}
