using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Contracts.Project;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Api.Controllers;
[Authorize][ApiController][Route("api/project/boards/{boardId:guid}")]
public sealed class ProjectMetricsController(ISprint7BiProjectService service) : ControllerBase
{
    private static readonly Guid TenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
    [HttpGet("metrics")] public async Task<IActionResult> Metrics(Guid boardId, CancellationToken ct) => Ok(await service.MetricsAsync(TenantId, boardId, ct));
    [HttpGet("feed")] public async Task<IActionResult> Feed(Guid boardId, CancellationToken ct) => Ok(await service.FeedAsync(TenantId, boardId, ct));
    [HttpGet("velocity")] public async Task<IActionResult> Velocity(Guid boardId, CancellationToken ct) => Ok(await service.VelocityAsync(TenantId, boardId, ct));
    [HttpGet("burndown")] public async Task<IActionResult> Burndown(Guid boardId, CancellationToken ct) => Ok(await service.BurndownAsync(TenantId, boardId, ct));
    [HttpPost("export")] public async Task<IActionResult> Export(Guid boardId, CancellationToken ct) => Ok(await service.ExportAsync(TenantId, boardId, ct));
    [HttpPost("import")] public async Task<IActionResult> Import(Guid boardId, [FromBody] ProjectImportRequest request, CancellationToken ct) => Ok(await service.ImportAsync(TenantId, boardId, request, ct));
}
