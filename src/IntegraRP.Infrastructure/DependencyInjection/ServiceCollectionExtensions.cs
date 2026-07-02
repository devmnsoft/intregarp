using IntegraRP.Application.Abstractions.Services;
using IntegraRP.Application.Ai;
using IntegraRP.Application.Flow;
using IntegraRP.Application.Studio;
using IntegraRP.Infrastructure.Data;
using IntegraRP.Infrastructure.Data.Migrations;
using IntegraRP.Infrastructure.Services;
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
