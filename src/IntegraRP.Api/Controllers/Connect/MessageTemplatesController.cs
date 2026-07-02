using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Contracts.Connect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Connect;

[ApiController]
[Authorize]
[Route("api/connect/templates")]
public sealed class MessageTemplatesController(IConnectService connectService) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List([FromQuery] string? canal, CancellationToken cancellationToken) => Ok(await connectService.ListTemplatesAsync(TenantId, canal, cancellationToken));
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken cancellationToken) => Ok((await connectService.ListTemplatesAsync(TenantId, null, cancellationToken)).FirstOrDefault(x => x.Id == id));
    [HttpPost] public async Task<IActionResult> Create(CreateMessageTemplateRequest request, CancellationToken cancellationToken) => Ok(await connectService.CreateTemplateAsync(TenantId, request, cancellationToken));
    [HttpPut("{id:guid}")] public async Task<IActionResult> Update(Guid id, UpdateMessageTemplateRequest request, CancellationToken cancellationToken) => Ok(await connectService.UpdateTemplateAsync(TenantId, id, request, cancellationToken));
    [HttpPost("{id:guid}/render")] public async Task<IActionResult> Render(Guid id, RenderMessageTemplateRequest request, CancellationToken cancellationToken) => Ok(await connectService.RenderTemplateAsync(TenantId, id, request, cancellationToken));
}
