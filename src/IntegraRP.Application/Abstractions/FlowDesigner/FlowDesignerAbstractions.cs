using IntegraRP.Application.Common;
using IntegraRP.Contracts.FlowDesigner;

namespace IntegraRP.Application.Abstractions.FlowDesigner;

public interface IFlowDesignerService
{
    Task<Result<FlowDesignerVersionResponse>> GetVersionAsync(Guid tenantId, Guid versionId, CancellationToken ct);
    Task<Result<FlowDesignerVersionResponse>> SaveLayoutAsync(Guid tenantId, Guid versionId, FlowDesignerLayoutRequest request, CancellationToken ct);
    Task<Result<FlowDesignerElementResponse>> AddElementAsync(Guid tenantId, Guid versionId, AddDesignerElementRequest request, CancellationToken ct);
    Task<Result<FlowDesignerElementResponse>> UpdateElementAsync(Guid tenantId, Guid versionId, Guid elementId, UpdateDesignerElementRequest request, CancellationToken ct);
    Task<Result<bool>> RemoveElementAsync(Guid tenantId, Guid versionId, Guid elementId, CancellationToken ct);
    Task<Result<FlowDesignerTransitionResponse>> AddTransitionAsync(Guid tenantId, Guid versionId, AddDesignerTransitionRequest request, CancellationToken ct);
    Task<Result<FlowDesignerTransitionResponse>> UpdateTransitionAsync(Guid tenantId, Guid versionId, Guid transitionId, UpdateDesignerTransitionRequest request, CancellationToken ct);
    Task<Result<bool>> RemoveTransitionAsync(Guid tenantId, Guid versionId, Guid transitionId, CancellationToken ct);
    Task<Result<FlowDesignerElementResponse>> SaveFormAsync(Guid tenantId, Guid versionId, Guid elementId, SaveElementFormSchemaRequest request, CancellationToken ct);
    Task<Result<FlowDesignerElementResponse>> SaveChecklistAsync(Guid tenantId, Guid versionId, Guid elementId, SaveElementChecklistRequest request, CancellationToken ct);
    Task<Result<ValidateFlowDesignerVersionResponse>> ValidateAsync(Guid tenantId, Guid versionId, CancellationToken ct);
    Task<Result<PublishFlowFromDesignerResponse>> PublishAsync(Guid tenantId, Guid versionId, PublishFlowFromDesignerRequest request, CancellationToken ct);
    Task<Result<FlowDesignerVersionResponse>> CreateDraftFromPublishedAsync(Guid tenantId, Guid definitionId, CancellationToken ct);
}

public interface IFlowTemplateRepository
{
    Task<Result<IReadOnlyList<FlowTemplateResponse>>> ListAsync(Guid tenantId, string? category, string? sector, int page, int pageSize, CancellationToken ct);
    Task<Result<FlowTemplateResponse>> GetAsync(Guid tenantId, Guid templateId, CancellationToken ct);
}

public interface IFlowDesignerHistoryRepository { Task<Result<IReadOnlyList<FlowDesignerHistoryResponse>>> ListAsync(Guid tenantId, Guid versionId, CancellationToken ct); Task AddAsync(Guid tenantId, Guid definitionId, Guid versionId, Guid? userId, string action, string description, string? beforeJson, string? afterJson, CancellationToken ct); }
public interface IFlowDesignerValidator { ValidateFlowDesignerVersionResponse Validate(FlowDesignerVersionResponse version); }
public interface IFlowTemplateCloner { Task<Result<CloneFlowTemplateResponse>> CloneAsync(Guid tenantId, Guid templateId, CloneFlowTemplateRequest request, CancellationToken ct); }
public interface IFlowDiagramSerializer { string Serialize(FlowDesignerVersionResponse version); }
public interface IFlowDesignerLayoutService { string BuildLayout(FlowDesignerVersionResponse version); }
public interface IFlowFormSchemaValidator { IReadOnlyList<FlowDesignerValidationIssueDto> Validate(FlowFormSchemaDto schema, Guid elementId); }
public interface IFlowChecklistSchemaValidator { IReadOnlyList<FlowDesignerValidationIssueDto> Validate(FlowChecklistSchemaDto schema, Guid elementId); }
