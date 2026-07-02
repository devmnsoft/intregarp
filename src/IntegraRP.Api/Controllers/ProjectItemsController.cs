using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Contracts.Project;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[Authorize][ApiController][Route("api/project")]
public sealed class ProjectItemsController(ISprint7BiProjectService service) : ControllerBase
{
    private static readonly Guid TenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
    [HttpGet("boards/{boardId:guid}/items")] public async Task<IActionResult> List(Guid boardId, CancellationToken ct) => Ok(await service.ListItemsAsync(TenantId, boardId, ct));
    [HttpGet("items/{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => Ok(await service.GetItemAsync(TenantId, id, ct));
    [HttpPost("boards/{boardId:guid}/items")] public async Task<IActionResult> Create(Guid boardId, [FromBody] CreateProjectItemRequest request, CancellationToken ct) => Ok(await service.CreateItemAsync(TenantId, boardId, request, ct));
    [HttpPut("items/{id:guid}")] public async Task<IActionResult> Update(Guid id, [FromBody] UpdateProjectItemRequest request, CancellationToken ct) => Ok(await service.UpdateItemAsync(TenantId, id, request, ct));
    [HttpPost("items/{id:guid}/move")] public async Task<IActionResult> Move(Guid id, [FromBody] MoveProjectItemRequest request, CancellationToken ct) => Ok(await service.MoveItemAsync(TenantId, id, request, ct));
    [HttpDelete("items/{id:guid}")] public async Task<IActionResult> Delete(Guid id, CancellationToken ct) { await service.DeleteItemAsync(TenantId, id, ct); return NoContent(); }
    [HttpPost("items/{id:guid}/comments")] public async Task<IActionResult> Comment(Guid id, [FromBody] AddProjectItemCommentRequest request, CancellationToken ct) => Ok(await service.AddCommentAsync(TenantId, id, request, ct));
    [HttpPost("items/{id:guid}/attachments")] public async Task<IActionResult> Attachment(Guid id, [FromBody] AddProjectItemCommentRequest request, CancellationToken ct) => Ok(await service.AddAttachmentAsync(TenantId, id, request, ct));
}
