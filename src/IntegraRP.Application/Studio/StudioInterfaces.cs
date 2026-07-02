using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;

namespace IntegraRP.Application.Studio;

public interface IDynamicModuleRepository { Task<IReadOnlyList<DynamicModuleResponse>> ListAsync(Guid tenantId, CancellationToken cancellationToken); Task<DynamicModuleResponse> CreateAsync(Guid tenantId, CreateDynamicModuleRequest request, CancellationToken cancellationToken); }
public interface IDynamicRecordRepository { Task<IReadOnlyList<DynamicRecordResponse>> ListAsync(Guid tenantId, string moduleCode, CancellationToken cancellationToken); Task<DynamicRecordResponse> CreateAsync(Guid tenantId, string moduleCode, UpsertDynamicRecordRequest request, CancellationToken cancellationToken); }
public interface IDynamicModuleBuilderService { Task<DynamicModuleResponse> AddFieldAsync(Guid tenantId, Guid moduleId, CreateDynamicFieldRequest request, CancellationToken cancellationToken); }
public interface IDynamicScreenGeneratorService { string GenerateListScreenJson(DynamicModuleResponse module); }
public interface IDynamicModuleIntegrationService { Task BindWorkflowAsync(Guid tenantId, Guid moduleId, Guid processId, CancellationToken cancellationToken); }
public interface IDynamicModuleSemanticCatalogService { Task RegisterAsync(Guid tenantId, Guid moduleId, string scope, CancellationToken cancellationToken); }
public interface ISmartModuleDraftService { Task<SmartModuleDraftResponse> SuggestAsync(Guid tenantId, SmartModuleDraftRequest request, CancellationToken cancellationToken); }
