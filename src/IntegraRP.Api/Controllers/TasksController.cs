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
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => ToAction(await useCases.GetTaskAsync(TenantId, id, ct));
    [HttpPost("{id:guid}/claim")] public async Task<IActionResult> Claim(Guid id, CancellationToken ct) => ToAction(await useCases.ClaimTaskAsync(TenantId, id, ct));
    [HttpPost("{id:guid}/comments")] public async Task<IActionResult> Comment(Guid id, CancellationToken ct) => ToAction(await useCases.CommentTaskAsync(TenantId, id, ct));
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, CancellationToken ct) => ToAction(await useCases.CompleteTaskAsync(TenantId, id, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
