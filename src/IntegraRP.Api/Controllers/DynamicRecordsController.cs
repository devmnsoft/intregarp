using IntegraRP.Application.Studio;
using IntegraRP.Contracts.Requests;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/dynamic/{moduleCode}")]
public sealed class DynamicRecordsController(IDynamicRecordRepository records, ILogger<DynamicRecordsController> logger) : IntegraControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(string moduleCode, CancellationToken cancellationToken) { try { return Ok(await records.ListAsync(TenantId, moduleCode, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } }

    [HttpPost]
    public async Task<IActionResult> Create(string moduleCode, [FromBody] UpsertDynamicRecordRequest request, CancellationToken cancellationToken) { try { return Ok(await records.CreateAsync(TenantId, moduleCode, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Create)); } }

    [HttpGet("{recordId:guid}")]
    public async Task<IActionResult> GetById(string moduleCode, Guid recordId, CancellationToken cancellationToken) { try { return Ok((await records.ListAsync(TenantId, moduleCode, cancellationToken)).FirstOrDefault(x => x.Id == recordId)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetById)); } }

    [HttpPut("{recordId:guid}")]
    public IActionResult Update(string moduleCode, Guid recordId, [FromBody] UpsertDynamicRecordRequest request) => Ok(new { moduleCode, recordId, request.Valores });

    [HttpPost("{recordId:guid}/acoes/{actionCode}")]
    public IActionResult ExecuteAction(string moduleCode, Guid recordId, string actionCode) => Ok(new { moduleCode, recordId, actionCode, status = "executed" });
}
