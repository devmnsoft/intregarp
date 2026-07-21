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
using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Infrastructure.Services.BillingConnect;
using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Application.Abstractions.Mobile;
using IntegraRP.Application.Abstractions.Ai;
using IntegraRP.Infrastructure.Services.Sprint7;
using IntegraRP.Application.Abstractions.OperationalTemplates;
using IntegraRP.Application.Abstractions.Operations;
using IntegraRP.Application.Runtime;
using IntegraRP.Application.Auth;
using IntegraRP.Infrastructure.Auth;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.DependencyInjection;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddSingleton<IDbConnectionFactory, NpgsqlConnectionFactory>();
        services.AddSingleton<PostgresConnectionFactory>();
        services.AddScoped<IAuthenticationRepository, PostgresAuthenticationRepository>();
        services.AddSingleton<IPasswordService, AspNetPasswordService>();
        services.AddSingleton<IRefreshTokenService, RefreshTokenService>();
        services.AddSingleton<ITokenService, JwtTokenService>();
        services.AddSingleton<IPasswordResetSender, DevelopmentPasswordResetSender>();
        services.AddSingleton<RepositoryTransactionRunner>();
        services.AddScoped<PostgresRepositoryReadiness>();
        services.AddScoped<IOperationalRuntimeRepository, PostgresV112OperationalRepository>();
        services.AddSingleton(new IntegraRpRepositoryOptions
        {
            UseInMemoryRepositories = configuration.GetValue<bool?>("IntegraRP:UseInMemoryRepositories") ?? false
        });
        services.AddScoped<IIntegraRpQueries, SeededIntegraRpQueries>();
        services.AddScoped<IMigrationRunner, PostgresMigrationRunner>();
        services.AddSingleton<IDataMaskingService, DataMaskingService>();
        services.AddSingleton<ILgpdAuditService, InMemoryLgpdAuditService>();
        services.AddSingleton<ISprint7BiProjectService, InMemoryBiProjectService>();
        services.AddSingleton<IKpiCalculator>(sp => sp.GetRequiredService<ISprint7BiProjectService>());
        services.AddSingleton<IKpiAggregationService>(sp => sp.GetRequiredService<ISprint7BiProjectService>());
        services.AddSingleton<IOperationalScoreService>(sp => sp.GetRequiredService<ISprint7BiProjectService>());
        services.AddSingleton<IDashboardQueryService>(sp => sp.GetRequiredService<ISprint7BiProjectService>());

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


        services.AddSingleton<InMemoryMobileFieldService>();
        services.AddSingleton<IMobileDeviceRepository>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileTaskRepository>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileEvidenceRepository>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileNotificationRepository>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileSyncRepository>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileDashboardService>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileTaskExecutionService>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileApprovalService>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IMobileStorageService>(sp => sp.GetRequiredService<InMemoryMobileFieldService>());
        services.AddSingleton<IAiIntentClassifierV2, RuleBasedIntentClassifierV2>();
        services.AddSingleton<IAiPermissionValidatorV2, AiPermissionValidatorV2>();
        services.AddSingleton<IAiToolRegistryV2, AiToolRegistryV2>();
        services.AddSingleton<IAiOrchestratorV2, AiOrchestratorV2>();
        services.AddSingleton<AiMemoryStore>();
        services.AddSingleton<IAiConversationRepositoryV2>(sp => sp.GetRequiredService<AiMemoryStore>());
        services.AddSingleton<IAiHumanEscalationServiceV2>(sp => sp.GetRequiredService<AiMemoryStore>());
        services.AddSingleton<IAiAuditServiceV2>(sp => sp.GetRequiredService<AiMemoryStore>());
        services.AddSingleton<IAiFeedbackService>(sp => sp.GetRequiredService<AiMemoryStore>());
        services.AddSingleton<IAiDataMaskingServiceV2, AiDataMaskingServiceV2>();
        services.AddSingleton<global::IntegraRP.Application.Abstractions.Ai.IAiProvider, FakeAiProviderV2>();
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_order_status", "Status de pedido", "ai.tool.order_status", "Pedido em separação, etapa conferência, responsável logística."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_delivery_proof", "Prova de entrega", "ai.tool.delivery_proof", "POD disponível com foto, assinatura e GPS mascarado."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_financial_title", "Título financeiro", "ai.tool.financial_title", "Título em aberto, vencimento futuro, valor R$ ***."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("search_dynamic_module", "Busca módulo dinâmico", "ai.tool.dynamic_module_search", "Consulta dinâmica autorizada retornou registros paginados."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_authorized_kpi", "KPI autorizado", "ai.tool.kpi", "KPI operacional permitido: SLA 92%."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("open_human_task", "Abrir tarefa humana", "ai.tool.open_human_task", "Tarefa humana criada para atendimento."));
        services.AddSingleton<OperationalSprint10Services>();
        services.AddSingleton<IOperationalTemplateRepository>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IOperationalTemplatePackageRepository>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IOperationalTemplateInstallationRepository>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IOperationalTemplateInstaller>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IOperationalTemplatePreviewService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IOperationalTemplateValidationService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IOperationalTemplateSeedService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IDeliveryRouteRepository>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IDeliveryManifestRepository>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IProofOfDeliveryRepository>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IDeliveryOccurrenceRepository>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IDeliveryMonitoringService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IDeliveryKpiService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IRoutePlanningService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IManifestService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IProofOfDeliveryService>(sp => sp.GetRequiredService<OperationalSprint10Services>());
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_delivery_status", "Status de entrega", "operations.deliveries.visualizar", "Entrega em rota; dados sensíveis mascarados; fallback humano em baixa confiança."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_route_status", "Status de rota", "operations.routes.visualizar", "Rota planejada/em execução com paradas autorizadas."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_manifest_status", "Status de romaneio", "operations.manifests.visualizar", "Romaneio conferido e pronto para expedição."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_damage_status", "Status de avaria", "operational.templates.visualizar", "Avaria com dados sensíveis mascarados."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_return_status", "Status de devolução", "operational.templates.visualizar", "Devolução em análise logística."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_promoter_visit_summary", "Resumo visita promotor", "operations.deliveries.visualizar", "Resumo autorizado de visita de campo."));
        services.AddSingleton<IAiToolV2>(new GovernedTool("get_operational_template_info", "Template operacional", "operational.templates.visualizar", "Informações do catálogo operacional instalado."));

        services.AddSingleton<IBoletoProvider, FakeBoletoProvider>();
        services.AddSingleton<IBillingService, InMemoryBillingService>();
        services.AddSingleton<IMessageTemplateRenderer, MessageTemplateRenderer>();
        services.AddSingleton<InMemoryConnectService>();
        services.AddSingleton<IConnectService>(sp => sp.GetRequiredService<InMemoryConnectService>());
        services.AddSingleton<IMessageDispatcher>(sp => sp.GetRequiredService<InMemoryConnectService>());
        services.AddSingleton<IOutboxProcessor>(sp => sp.GetRequiredService<InMemoryConnectService>());
        services.AddSingleton<IFiscalDocumentProvider, FakeFiscalDocumentProvider>();
        services.AddSingleton<IEmailSender, FakeEmailSender>();
        services.AddSingleton<IWhatsAppSender, FakeWhatsAppSender>();
        services.AddSingleton<ITelegramSender, FakeTelegramSender>();
        services.AddSingleton<IWebhookSender, FakeWebhookSender>();

        return services;
    }
}
