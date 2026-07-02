using IntegraRP.Application.Common;
using IntegraRP.Application.FlowDesigner.UseCases;
using IntegraRP.Contracts.FlowDesigner;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Tags("Flow Designer")]
public sealed class FlowDesignerController(ILogger<FlowDesignerController> logger) : IntegraControllerBase
{
    [HttpGet("api/flow/designer/templates")]
    public async Task<IActionResult> Templates([FromServices] ListFlowTemplatesUseCase useCase, [FromQuery] string? category, [FromQuery] string? sector, [FromQuery] int page = 1, [FromQuery] int pageSize = 50, CancellationToken ct = default) => await Run(() => useCase.ExecuteAsync(TenantId, category, sector, page, pageSize, ct), nameof(Templates));
    [HttpGet("api/flow/designer/templates/{templateId:guid}")]
    public async Task<IActionResult> Template(Guid templateId, [FromServices] GetFlowTemplateByIdUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, templateId, ct), nameof(Template));
    [HttpPost("api/flow/designer/templates/{templateId:guid}/clone")]
    public async Task<IActionResult> Clone(Guid templateId, [FromBody] CloneFlowTemplateRequest request, [FromServices] CloneFlowTemplateToProcessUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, templateId, request, ct), nameof(Clone));
    [HttpGet("api/flow/designer/versions/{versionId:guid}")]
    public async Task<IActionResult> Version(Guid versionId, [FromServices] GetFlowDesignerVersionUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, ct), nameof(Version));
    [HttpPost("api/flow/designer/definitions/{definitionId:guid}/draft-from-published")]
    public async Task<IActionResult> Draft(Guid definitionId, [FromServices] CreateDraftFromPublishedVersionUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, definitionId, ct), nameof(Draft));
    [HttpPut("api/flow/designer/versions/{versionId:guid}/layout")]
    public async Task<IActionResult> Layout(Guid versionId, [FromBody] FlowDesignerLayoutRequest request, [FromServices] SaveFlowDesignerLayoutUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, request, ct), nameof(Layout));
    [HttpPost("api/flow/designer/versions/{versionId:guid}/elements")]
    public async Task<IActionResult> AddElement(Guid versionId, [FromBody] AddDesignerElementRequest request, [FromServices] AddDesignerElementUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, request, ct), nameof(AddElement));
    [HttpPut("api/flow/designer/versions/{versionId:guid}/elements/{elementId:guid}")]
    public async Task<IActionResult> UpdateElement(Guid versionId, Guid elementId, [FromBody] UpdateDesignerElementRequest request, [FromServices] UpdateDesignerElementUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, elementId, request, ct), nameof(UpdateElement));
    [HttpDelete("api/flow/designer/versions/{versionId:guid}/elements/{elementId:guid}")]
    public async Task<IActionResult> RemoveElement(Guid versionId, Guid elementId, [FromServices] RemoveDesignerElementUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, elementId, ct), nameof(RemoveElement));
    [HttpPost("api/flow/designer/versions/{versionId:guid}/transitions")]
    public async Task<IActionResult> AddTransition(Guid versionId, [FromBody] AddDesignerTransitionRequest request, [FromServices] AddDesignerTransitionUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, request, ct), nameof(AddTransition));
    [HttpPut("api/flow/designer/versions/{versionId:guid}/transitions/{transitionId:guid}")]
    public async Task<IActionResult> UpdateTransition(Guid versionId, Guid transitionId, [FromBody] UpdateDesignerTransitionRequest request, [FromServices] UpdateDesignerTransitionUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, transitionId, request, ct), nameof(UpdateTransition));
    [HttpDelete("api/flow/designer/versions/{versionId:guid}/transitions/{transitionId:guid}")]
    public async Task<IActionResult> RemoveTransition(Guid versionId, Guid transitionId, [FromServices] RemoveDesignerTransitionUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, transitionId, ct), nameof(RemoveTransition));
    [HttpPut("api/flow/designer/versions/{versionId:guid}/elements/{elementId:guid}/form")]
    public async Task<IActionResult> Form(Guid versionId, Guid elementId, [FromBody] SaveElementFormSchemaRequest request, [FromServices] SaveElementFormSchemaUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, elementId, request, ct), nameof(Form));
    [HttpPut("api/flow/designer/versions/{versionId:guid}/elements/{elementId:guid}/checklist")]
    public async Task<IActionResult> Checklist(Guid versionId, Guid elementId, [FromBody] SaveElementChecklistRequest request, [FromServices] SaveElementChecklistUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, elementId, request, ct), nameof(Checklist));
    [HttpPost("api/flow/designer/versions/{versionId:guid}/validate")]
    public async Task<IActionResult> Validate(Guid versionId, [FromServices] ValidateFlowDesignerVersionUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, ct), nameof(Validate));
    [HttpPost("api/flow/designer/versions/{versionId:guid}/publish")]
    public async Task<IActionResult> Publish(Guid versionId, [FromBody] PublishFlowFromDesignerRequest request, [FromServices] PublishFlowFromDesignerUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, request, ct), nameof(Publish));
    [HttpGet("api/flow/designer/versions/{versionId:guid}/history")]
    public async Task<IActionResult> History(Guid versionId, [FromServices] GetDesignerHistoryUseCase useCase, CancellationToken ct) => await Run(() => useCase.ExecuteAsync(TenantId, versionId, ct), nameof(History));

    private async Task<IActionResult> Run<T>(Func<Task<Result<T>>> action, string operation)
    {
        try
        {
            var result = await action();
            return result.IsSuccess ? Ok(result.Value) : Problem(title: "Flow Designer", detail: result.Error, statusCode: StatusCodes.Status400BadRequest);
        }
        catch (Exception ex)
        {
            return ProblemFrom(ex, logger, operation);
        }
    }
}
