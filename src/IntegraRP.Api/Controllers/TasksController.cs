using IntegraRP.Application.Runtime;
using IntegraRP.Api.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/tasks")]
public sealed class TasksController(OperationalRuntimeUseCases useCases, ICurrentUserContext currentUser) : IntegraControllerBase
{
    [Authorize(Policy = "tasks.view")]
    [HttpGet("my")] public async Task<IActionResult> My(CancellationToken ct) => ToAction(await useCases.ListMyTasksAsync(currentUser, ct));
    [Authorize(Policy = "tasks.view")]
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => ToAction(await useCases.GetTaskAsync(TenantId, id, ct));
    [Authorize(Policy = "tasks.claim")]
    [HttpPost("{id:guid}/claim")] public async Task<IActionResult> Claim(Guid id, CancellationToken ct) => ToAction(await useCases.ClaimTaskAsync(currentUser, id, ct));
    [Authorize(Policy = "tasks.view")]
    [HttpPost("{id:guid}/comments")] public async Task<IActionResult> Comment(Guid id, AddTaskCommentRequest request, CancellationToken ct) => ToAction(await useCases.CommentTaskAsync(currentUser, id, request, ct));
    [Authorize(Policy = "tasks.complete")]
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, CancellationToken ct) => ToAction(await useCases.CompleteTaskAsync(TenantId, id, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(title: "Falha de validação", detail: result.Error, statusCode: 400);
}
