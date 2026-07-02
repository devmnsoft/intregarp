using IntegraRP.Contracts.Bi;
using IntegraRP.Contracts.Project;

namespace IntegraRP.Application.Abstractions.Bi;

public interface IKpiDefinitionRepository { }
public interface IKpiValueRepository { }
public interface IKpiTargetRepository { }
public interface IKpiAlertRepository { }
public interface IOperationalScoreRepository { }
public interface IDashboardRepository { }
public interface IAnalyticsRepository { }
public interface IKpiCalculator { Task<IReadOnlyList<KpiValueResponse>> CalculateAllAsync(Guid tenantId, CancellationToken ct); }
public interface IKpiAggregationService { Task AggregateAsync(CancellationToken ct); }
public interface IOperationalScoreService { Task<OperationalScoreResponse> RecalculateAsync(Guid tenantId, CancellationToken ct); }
public interface IDashboardQueryService
{
    Task<ExecutiveDashboardResponse> ExecutiveAsync(Guid tenantId, CancellationToken ct);
    Task<FlowBiDashboardResponse> FlowAsync(Guid tenantId, CancellationToken ct);
    Task<CommercialBiDashboardResponse> CommercialAsync(Guid tenantId, CancellationToken ct);
    Task<InventoryBiDashboardResponse> InventoryAsync(Guid tenantId, CancellationToken ct);
    Task<BillingBiDashboardResponse> BillingAsync(Guid tenantId, CancellationToken ct);
    Task<ConnectBiDashboardResponse> ConnectAsync(Guid tenantId, CancellationToken ct);
}

public interface ISprint7BiProjectService : IKpiCalculator, IKpiAggregationService, IOperationalScoreService, IDashboardQueryService
{
    Task<IReadOnlyList<KpiDefinitionResponse>> ListKpisAsync(Guid tenantId, CancellationToken ct);
    Task<KpiDefinitionResponse> CreateKpiAsync(Guid tenantId, CreateKpiDefinitionRequest request, CancellationToken ct);
    Task<KpiDefinitionResponse> UpdateKpiAsync(Guid tenantId, Guid id, UpdateKpiDefinitionRequest request, CancellationToken ct);
    Task<KpiTargetResponse> SetTargetAsync(Guid tenantId, Guid id, SetKpiTargetRequest request, CancellationToken ct);
    Task<IReadOnlyList<KpiAlertResponse>> AlertsAsync(Guid tenantId, CancellationToken ct);
    Task<OperationalScoreResponse> ScoreAsync(Guid tenantId, CancellationToken ct);
    Task<IReadOnlyList<ProjectBoardResponse>> ListBoardsAsync(Guid tenantId, CancellationToken ct);
    Task<ProjectBoardDetailResponse> GetBoardAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<ProjectBoardResponse> CreateBoardAsync(Guid tenantId, CreateProjectBoardRequest request, CancellationToken ct);
    Task<ProjectBoardResponse> UpdateBoardAsync(Guid tenantId, Guid boardId, UpdateProjectBoardRequest request, CancellationToken ct);
    Task DeleteBoardAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<IReadOnlyList<ProjectColumnResponse>> CreateDefaultColumnsAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<IReadOnlyList<ProjectSprintResponse>> ListSprintsAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<ProjectSprintResponse> CreateSprintAsync(Guid tenantId, Guid boardId, CreateProjectSprintRequest request, CancellationToken ct);
    Task<ProjectSprintResponse> UpdateSprintAsync(Guid tenantId, Guid id, UpdateProjectSprintRequest request, CancellationToken ct);
    Task<ProjectSprintResponse> ActivateSprintAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<ProjectSprintResponse> CloseSprintAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IReadOnlyList<ProjectColumnResponse>> ListColumnsAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<ProjectColumnResponse> CreateColumnAsync(Guid tenantId, Guid boardId, CreateProjectColumnRequest request, CancellationToken ct);
    Task<ProjectColumnResponse> UpdateColumnAsync(Guid tenantId, Guid id, UpdateProjectColumnRequest request, CancellationToken ct);
    Task<ProjectColumnResponse> MoveColumnAsync(Guid tenantId, Guid id, MoveProjectColumnRequest request, CancellationToken ct);
    Task DeleteColumnAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<IReadOnlyList<ProjectItemResponse>> ListItemsAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<ProjectItemDetailResponse> GetItemAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<ProjectItemResponse> CreateItemAsync(Guid tenantId, Guid boardId, CreateProjectItemRequest request, CancellationToken ct);
    Task<ProjectItemResponse> UpdateItemAsync(Guid tenantId, Guid id, UpdateProjectItemRequest request, CancellationToken ct);
    Task<ProjectItemResponse> MoveItemAsync(Guid tenantId, Guid id, MoveProjectItemRequest request, CancellationToken ct);
    Task DeleteItemAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<ProjectItemCommentResponse> AddCommentAsync(Guid tenantId, Guid id, AddProjectItemCommentRequest request, CancellationToken ct);
    Task<ProjectItemCommentResponse> AddAttachmentAsync(Guid tenantId, Guid id, AddProjectItemCommentRequest request, CancellationToken ct);
    Task<ProjectMetricsResponse> MetricsAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<IReadOnlyList<ProjectFeedEventResponse>> FeedAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<IReadOnlyList<ProjectVelocityResponse>> VelocityAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<IReadOnlyList<ProjectBurndownResponse>> BurndownAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<ProjectExportResponse> ExportAsync(Guid tenantId, Guid boardId, CancellationToken ct);
    Task<ProjectImportResponse> ImportAsync(Guid tenantId, Guid boardId, ProjectImportRequest request, CancellationToken ct);
}
