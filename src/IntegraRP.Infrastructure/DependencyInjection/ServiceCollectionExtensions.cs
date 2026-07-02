using IntegraRP.Application.Abstractions.Services;
using IntegraRP.Application.Ai;
using IntegraRP.Application.Flow;
using IntegraRP.Application.Studio;
using IntegraRP.Infrastructure.Data;
using IntegraRP.Infrastructure.Data.Migrations;
using IntegraRP.Infrastructure.Services;
using IntegraRP.Infrastructure.Services.FlowDesigner;
using IntegraRP.Application.Abstractions.FlowDesigner;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace IntegraRP.Infrastructure.DependencyInjection;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddSingleton<IDbConnectionFactory, NpgsqlConnectionFactory>();
        services.AddScoped<IIntegraRpQueries, SeededIntegraRpQueries>();
        services.AddScoped<IMigrationRunner, PostgresMigrationRunner>();

        services.AddSingleton<InMemoryFlowServices>();
        services.AddSingleton<IProcessDefinitionRepository>(sp => sp.GetRequiredService<InMemoryFlowServices>());
        services.AddSingleton<IProcessInstanceRepository>(sp => sp.GetRequiredService<InMemoryFlowServices>());
        services.AddSingleton<IWorkflowTaskRepository>(sp => sp.GetRequiredService<InMemoryFlowServices>());
        services.AddSingleton<IWorkflowEngine>(sp => sp.GetRequiredService<InMemoryFlowServices>());
        services.AddSingleton<IProcessPublisher>(sp => sp.GetRequiredService<InMemoryFlowServices>());
        services.AddSingleton<IWorkflowEventDispatcher>(sp => sp.GetRequiredService<InMemoryFlowServices>());
        services.AddSingleton<IWorkflowGatewayEvaluator>(sp => sp.GetRequiredService<InMemoryFlowServices>());


        services.AddSingleton<InMemoryFlowCoreServices>();
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IProcessDefinitionRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IProcessVersionRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IProcessElementRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IProcessTransitionRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IProcessInstanceRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowTaskRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowAuditRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IBusinessEventRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IOutboxEventRepository>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowEngine>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowGatewayEvaluator>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowTaskFactory>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowEventPublisher>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowSlaCalculator>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IWorkflowCodeGenerator>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());
        services.AddSingleton<IntegraRP.Application.Abstractions.Flow.IUnitOfWork>(sp => sp.GetRequiredService<InMemoryFlowCoreServices>());

        services.AddSingleton<InMemoryFlowDesignerServices>();
        services.AddSingleton<IFlowDesignerService>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowTemplateRepository>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowDesignerHistoryRepository>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowDesignerValidator>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowTemplateCloner>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowDiagramSerializer>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowDesignerLayoutService>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowFormSchemaValidator>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());
        services.AddSingleton<IFlowChecklistSchemaValidator>(sp => sp.GetRequiredService<InMemoryFlowDesignerServices>());

        services.AddSingleton<InMemoryStudioServices>();
        services.AddSingleton<IDynamicModuleRepository>(sp => sp.GetRequiredService<InMemoryStudioServices>());
        services.AddSingleton<IDynamicRecordRepository>(sp => sp.GetRequiredService<InMemoryStudioServices>());
        services.AddSingleton<IDynamicModuleBuilderService>(sp => sp.GetRequiredService<InMemoryStudioServices>());
        services.AddSingleton<IDynamicScreenGeneratorService>(sp => sp.GetRequiredService<InMemoryStudioServices>());
        services.AddSingleton<IDynamicModuleIntegrationService>(sp => sp.GetRequiredService<InMemoryStudioServices>());
        services.AddSingleton<IDynamicModuleSemanticCatalogService>(sp => sp.GetRequiredService<InMemoryStudioServices>());
        services.AddSingleton<ISmartModuleDraftService>(sp => sp.GetRequiredService<InMemoryStudioServices>());

        services.AddScoped<IAiOrchestrator, AiOrchestrator>();
        services.AddSingleton<IAiIntentClassifier, RuleBasedIntentClassifier>();
        services.AddSingleton<IAiPermissionValidator, AiPermissionValidator>();
        services.AddSingleton<IAiToolRegistry, AiToolRegistry>();
        services.AddSingleton<IAiResponseGenerator, AiResponseGenerator>();
        services.AddSingleton<IAiAuditService, AiAuditService>();
        services.AddSingleton<IHumanEscalationService, HumanEscalationService>();
        services.AddSingleton<IAiDataMaskingService, AiDataMaskingService>();
        services.AddSingleton<IAiConversationRepository, AiConversationRepository>();
        services.AddSingleton<IAiTool, GetOrderStatusTool>();
        services.AddSingleton<IAiTool, GetDeliveryProofTool>();
        services.AddSingleton<IAiTool, GetFinancialTitleTool>();
        services.AddSingleton<IAiTool, SearchDynamicModuleTool>();
        services.AddSingleton<IAiTool, GetAuthorizedKpiTool>();
        services.AddSingleton<IAiTool, OpenHumanTaskTool>();

        return services;
    }
}
