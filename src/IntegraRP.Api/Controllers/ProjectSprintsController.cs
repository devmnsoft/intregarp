using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Contracts.Project;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[Authorize][ApiController][Route("api/project")]
public sealed class ProjectSprintsController(ISprint7BiProjectService service) : ControllerBase
{
    private static readonly Guid TenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
    [HttpGet("boards/{boardId:guid}/sprints")] public async Task<IActionResult> List(Guid boardId, CancellationToken ct) => Ok(await service.ListSprintsAsync(TenantId, boardId, ct));
    [HttpPost("boards/{boardId:guid}/sprints")] public async Task<IActionResult> Create(Guid boardId, [FromBody] CreateProjectSprintRequest request, CancellationToken ct) => Ok(await service.CreateSprintAsync(TenantId, boardId, request, ct));
    [HttpPut("sprints/{id:guid}")] public async Task<IActionResult> Update(Guid id, [FromBody] UpdateProjectSprintRequest request, CancellationToken ct) => Ok(await service.UpdateSprintAsync(TenantId, id, request, ct));
    [HttpPost("sprints/{id:guid}/activate")] public async Task<IActionResult> Activate(Guid id, CancellationToken ct) => Ok(await service.ActivateSprintAsync(TenantId, id, ct));
    [HttpPost("sprints/{id:guid}/close")] public async Task<IActionResult> Close(Guid id, CancellationToken ct) => Ok(await service.CloseSprintAsync(TenantId, id, ct));
}
