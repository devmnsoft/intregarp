using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Contracts.Connect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Connect;

[ApiController]
[Authorize]
[Route("api/connect/messages")]
public sealed class MessagesController(IConnectService connectService) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List([FromQuery] string? status, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken cancellationToken = default) => Ok(await connectService.ListMessagesAsync(TenantId, status, page, pageSize, cancellationToken));
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken cancellationToken) => Ok((await connectService.ListMessagesAsync(TenantId, null, 1, 100, cancellationToken)).FirstOrDefault(x => x.Id == id));
    [HttpPost("send")] public async Task<IActionResult> Send(SendMessageRequest request, CancellationToken cancellationToken) => Ok(await connectService.SendMessageAsync(TenantId, request, cancellationToken));
    [HttpPost("queue")] public async Task<IActionResult> Queue(QueueMessageRequest request, CancellationToken cancellationToken) => Ok(await connectService.QueueOutboxAsync(TenantId, new QueueOutboxEventRequest(request.TipoEvento, request.Canal, request.OrigemTipo, request.OrigemId, "normal", request.Payload), cancellationToken));
    [HttpPost("{id:guid}/retry")] public IActionResult Retry(Guid id, RetryMessageDispatchRequest request) => Ok(new { id, status = "reprocessado", request.Motivo });
}
