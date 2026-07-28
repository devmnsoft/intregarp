using IntegraRP.Application.Commercial;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController, Authorize, Route("api/notifications")]
public sealed class NotificationsController(ListNotificationsUseCase list, GetUnreadNotificationCountUseCase unread, MarkNotificationReadUseCase markRead, MarkAllNotificationsReadUseCase markAll) : ControllerBase
{
    private Guid Claim(string name) => Guid.TryParse(User.FindFirst(name)?.Value, out var id) ? id : throw new UnauthorizedAccessException($"Claim obrigatória ausente: {name}.");
    [HttpGet] public async Task<IActionResult> Get([FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken ct = default) => Ok(await list.ExecuteAsync(Claim("tenant_id"), Claim("sub"), page, pageSize, ct));
    [HttpGet("unread-count")] public async Task<IActionResult> Unread(CancellationToken ct) => Ok(new { count = await unread.ExecuteAsync(Claim("tenant_id"), Claim("sub"), ct) });
    [HttpPost("{id:guid}/read")] public async Task<IActionResult> Read(Guid id, CancellationToken ct) => Ok(await markRead.ExecuteAsync(Claim("tenant_id"), Claim("sub"), id, ct));
    [HttpPost("read-all")] public async Task<IActionResult> ReadAll(CancellationToken ct) => Ok(new { updated = await markAll.ExecuteAsync(Claim("tenant_id"), Claim("sub"), ct) });
}
