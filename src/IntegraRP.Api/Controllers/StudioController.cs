using IntegraRP.Application.Studio;
using IntegraRP.Contracts.Requests;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/studio")]
public sealed class StudioController(IDynamicModuleRepository modules, IDynamicModuleBuilderService builder, ISmartModuleDraftService smartDraft, ILogger<StudioController> logger) : IntegraControllerBase
{
    [HttpGet("modulos")]
    [HttpGet("modules")]
    public async Task<IActionResult> GetModules(CancellationToken cancellationToken) { try { return Ok(await modules.ListAsync(TenantId, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetModules)); } }

    [HttpPost("modulos")]
    [HttpPost("modules")]
    public async Task<IActionResult> CreateModule([FromBody] CreateDynamicModuleRequest request, CancellationToken cancellationToken) { try { return Ok(await modules.CreateAsync(TenantId, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(CreateModule)); } }

    [HttpGet("modulos/{id:guid}")]
    [HttpGet("modules/{id:guid}")]
    public async Task<IActionResult> GetModule(Guid id, CancellationToken cancellationToken) { try { return Ok((await modules.ListAsync(TenantId, cancellationToken)).FirstOrDefault(x => x.Id == id)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetModule)); } }

    [HttpPut("modulos/{id:guid}")]
    [HttpPut("modules/{id:guid}")]
    public IActionResult UpdateModule(Guid id, [FromBody] CreateDynamicModuleRequest request) => Ok(new { id, request.Nome, request.Codigo });

    [HttpPost("modulos/{id:guid}/entidades")]
    public IActionResult AddEntity(Guid id, [FromBody] object request) => Ok(new { moduleId = id, request });

    [HttpPost("modulos/{id:guid}/campos")]
    [HttpPost("entities/{id:guid}/fields")]
    public async Task<IActionResult> AddField(Guid id, [FromBody] CreateDynamicFieldRequest request, CancellationToken cancellationToken) { try { return Ok(await builder.AddFieldAsync(TenantId, id, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(AddField)); } }

    [HttpPost("modulos/{id:guid}/acoes")]
    [HttpPost("modules/{id:guid}/actions")]
    public IActionResult AddAction(Guid id, [FromBody] CreateDynamicActionRequest request) => Ok(new { moduleId = id, request });

    [HttpPost("modulos/{id:guid}/relacionamentos")]
    [HttpPost("modules/{id:guid}/relationships")]
    public IActionResult AddRelationship(Guid id, [FromBody] object request) => Ok(new { moduleId = id, request });

    [HttpPost("modulos/{id:guid}/bpmn")]
    [HttpPost("modules/{id:guid}/bpmn-bindings")]
    public IActionResult BindBpmn(Guid id, [FromBody] object request) => Ok(new { moduleId = id, request });

    [HttpPost("modulos/{id:guid}/catalogo-semantico")]
    [HttpPut("modules/{id:guid}/semantic-catalog")]
    public IActionResult SemanticCatalog(Guid id, [FromBody] object request) => Ok(new { moduleId = id, request });

    [HttpPost("sugerir-modulo")]
    [HttpPost("suggest-module")]
    public async Task<IActionResult> Suggest([FromBody] SmartModuleDraftRequest request, CancellationToken cancellationToken) { try { return Ok(await smartDraft.SuggestAsync(TenantId, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Suggest)); } }
}
