using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Contracts.Project;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/project/boards")]
public sealed class ProjectBoardsController(ILogger<ProjectBoardsController> logger, ISprint7BiProjectService service) : ControllerBase
{
    private static readonly Guid TenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => Ok(await service.ListBoardsAsync(TenantId, ct));
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => Ok(await service.GetBoardAsync(TenantId, id, ct));
    [HttpPost] public async Task<IActionResult> Create([FromBody] CreateProjectBoardRequest request, CancellationToken ct) { logger.LogInformation("Criando board"); return Ok(await service.CreateBoardAsync(TenantId, request, ct)); }
    [HttpPut("{id:guid}")] public async Task<IActionResult> Update(Guid id, [FromBody] UpdateProjectBoardRequest request, CancellationToken ct) => Ok(await service.UpdateBoardAsync(TenantId, id, request, ct));
    [HttpDelete("{id:guid}")] public async Task<IActionResult> Delete(Guid id, CancellationToken ct) { await service.DeleteBoardAsync(TenantId, id, ct); return NoContent(); }
    [HttpPost("{id:guid}/columns/default")] public async Task<IActionResult> Defaults(Guid id, CancellationToken ct) => Ok(await service.CreateDefaultColumnsAsync(TenantId, id, ct));
}
