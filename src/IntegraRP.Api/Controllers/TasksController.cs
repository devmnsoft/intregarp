using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/tasks")]
public sealed class TasksController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [HttpGet("my")] public async Task<IActionResult> My(CancellationToken ct) => ToAction(await useCases.ListMyTasksAsync(TenantId, ct));
    [HttpGet("{id:guid}")] public IActionResult Get(Guid id) => Problem("Consulta por id será consolidada no repository dedicado.", statusCode: 501);
    [HttpPost("{id:guid}/claim")] public IActionResult Claim(Guid id) => Problem("Assumir tarefa será consolidado no use case dedicado.", statusCode: 501);
    [HttpPost("{id:guid}/comments")] public IActionResult Comment(Guid id) => Problem("Comentários serão consolidados no use case dedicado.", statusCode: 501);
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, CancellationToken ct) => ToAction(await useCases.CompleteTaskAsync(TenantId, id, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
