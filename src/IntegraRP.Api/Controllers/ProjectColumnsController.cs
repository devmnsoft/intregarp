using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Contracts.Project;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[Authorize][ApiController][Route("api/project")]
public sealed class ProjectColumnsController(ISprint7BiProjectService service) : ControllerBase
{
    private static readonly Guid TenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
    [HttpGet("boards/{boardId:guid}/columns")] public async Task<IActionResult> List(Guid boardId, CancellationToken ct) => Ok(await service.ListColumnsAsync(TenantId, boardId, ct));
    [HttpPost("boards/{boardId:guid}/columns")] public async Task<IActionResult> Create(Guid boardId, [FromBody] CreateProjectColumnRequest request, CancellationToken ct) => Ok(await service.CreateColumnAsync(TenantId, boardId, request, ct));
    [HttpPut("columns/{id:guid}")] public async Task<IActionResult> Update(Guid id, [FromBody] UpdateProjectColumnRequest request, CancellationToken ct) => Ok(await service.UpdateColumnAsync(TenantId, id, request, ct));
    [HttpPost("columns/{id:guid}/move")] public async Task<IActionResult> Move(Guid id, [FromBody] MoveProjectColumnRequest request, CancellationToken ct) => Ok(await service.MoveColumnAsync(TenantId, id, request, ct));
    [HttpDelete("columns/{id:guid}")] public async Task<IActionResult> Delete(Guid id, CancellationToken ct) { await service.DeleteColumnAsync(TenantId, id, ct); return NoContent(); }
}
