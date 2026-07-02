using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Contracts.Connect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Connect;

[ApiController]
[Authorize]
[Route("api/connect/outbox")]
public sealed class OutboxController(IConnectService connectService) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List([FromQuery] string? status, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken cancellationToken = default) => Ok(await connectService.ListOutboxAsync(TenantId, status, page, pageSize, cancellationToken));
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken cancellationToken) => (await connectService.GetOutboxAsync(TenantId, id, cancellationToken)) is { } item ? Ok(item) : NotFound();
    [HttpPost] public async Task<IActionResult> Queue(QueueOutboxEventRequest request, CancellationToken cancellationToken) => Ok(await connectService.QueueOutboxAsync(TenantId, request, cancellationToken));
    [HttpPost("{id:guid}/process")] public async Task<IActionResult> Process(Guid id, CancellationToken cancellationToken) => Ok(await connectService.ProcessOutboxAsync(TenantId, id, cancellationToken));
    [HttpPost("{id:guid}/retry")] public async Task<IActionResult> Retry(Guid id, RetryOutboxEventRequest request, CancellationToken cancellationToken) => Ok(await connectService.ProcessOutboxAsync(TenantId, id, cancellationToken));
    [HttpPost("{id:guid}/cancel")] public IActionResult Cancel(Guid id) => Ok(new { id, status = "cancelado" });
}
