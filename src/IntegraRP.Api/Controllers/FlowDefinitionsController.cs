using IntegraRP.Application.Abstractions.Flow;
using IntegraRP.Contracts.Flow;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/flow/definitions")]
[Tags("Flow Definitions")]
public sealed class FlowDefinitionsController(IProcessDefinitionRepository definitions, ILogger<FlowDefinitionsController> logger) : IntegraControllerBase
{
    [HttpGet]
    public async Task<IActionResult> List(CancellationToken ct) { try { return Ok(await definitions.ListAsync(TenantId, 1, 50, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("{id:guid}")]
    public async Task<IActionResult> Get(Guid id, CancellationToken ct) { try { return Ok(await definitions.GetAsync(TenantId, id, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } }
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateProcessDefinitionRequest request, CancellationToken ct) { try { return Ok(await definitions.CreateAsync(TenantId, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Create)); } }
    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateProcessDefinitionRequest request, CancellationToken ct) { try { return Ok(await definitions.UpdateAsync(TenantId, id, request, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Update)); } }
    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Archive(Guid id, CancellationToken ct) { try { await definitions.ArchiveAsync(TenantId, id, ct); return NoContent(); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Archive)); } }
}
