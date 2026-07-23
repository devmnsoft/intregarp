using IntegraRP.Application.Auth;
using IntegraRP.Application.FlowDesigner.UseCases;
using IntegraRP.Application.OperationalTemplates;
using IntegraRP.Application.Operations;
using IntegraRP.Application.Runtime;
using Microsoft.Extensions.DependencyInjection;
using IntegraRP.Application.Commercial;

namespace IntegraRP.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<LoginUseCase>();
        services.AddScoped<IAuthenticationService, AuthenticationService>();
        services.AddScoped<RefreshTokenUseCase>();
        services.AddScoped<LogoutUseCase>();
        services.AddScoped<ChangePasswordUseCase>();
        services.AddScoped<ForgotPasswordUseCase>();
        services.AddScoped<ResetPasswordUseCase>();
        services.AddScoped<GetCurrentUserUseCase>();
        services.AddScoped<OperationalRuntimeUseCases>();
        services.AddScoped<ListFlowTemplatesUseCase>();
        services.AddScoped<GetFlowTemplateByIdUseCase>();
        services.AddScoped<CloneFlowTemplateToProcessUseCase>();
        services.AddScoped<GetFlowDesignerVersionUseCase>();
        services.AddScoped<SaveFlowDesignerLayoutUseCase>();
        services.AddScoped<AddDesignerElementUseCase>();
        services.AddScoped<UpdateDesignerElementUseCase>();
        services.AddScoped<RemoveDesignerElementUseCase>();
        services.AddScoped<AddDesignerTransitionUseCase>();
        services.AddScoped<UpdateDesignerTransitionUseCase>();
        services.AddScoped<RemoveDesignerTransitionUseCase>();
        services.AddScoped<SaveElementFormSchemaUseCase>();
        services.AddScoped<SaveElementChecklistUseCase>();
        services.AddScoped<ValidateFlowDesignerVersionUseCase>();
        services.AddScoped<PublishFlowFromDesignerUseCase>();
        services.AddScoped<CreateDraftFromPublishedVersionUseCase>();
        services.AddScoped<GetDesignerHistoryUseCase>();
        services.AddScoped<ListOperationalTemplatePackagesUseCase>();
        services.AddScoped<ListOperationalTemplatesUseCase>();
        services.AddScoped<GetOperationalTemplateByIdUseCase>();
        services.AddScoped<PreviewOperationalTemplateUseCase>();
        services.AddScoped<InstallOperationalTemplateUseCase>();
        services.AddScoped<InstallOperationalTemplatePackageUseCase>();
        services.AddScoped<ListOperationalTemplateInstallationsUseCase>();
        services.AddScoped<GetOperationalTemplateInstallationLogUseCase>();
        services.AddScoped<ValidateOperationalTemplateUseCase>();
        services.AddScoped<CreateDeliveryRouteUseCase>();
        services.AddScoped<UpdateDeliveryRouteUseCase>();
        services.AddScoped<ListDeliveryRoutesUseCase>();
        services.AddScoped<GetDeliveryRouteByIdUseCase>();
        services.AddScoped<AddDeliveryRouteStopUseCase>();
        services.AddScoped<ReorderDeliveryRouteStopsUseCase>();
        services.AddScoped<StartDeliveryRouteUseCase>();
        services.AddScoped<CompleteDeliveryRouteUseCase>();
        services.AddScoped<CancelDeliveryRouteUseCase>();
        services.AddScoped<CreateDeliveryManifestUseCase>();
        services.AddScoped<AddDeliveryManifestItemUseCase>();
        services.AddScoped<ConfirmDeliveryManifestUseCase>();
        services.AddScoped<StartManifestRouteUseCase>();
        services.AddScoped<CompleteDeliveryManifestUseCase>();
        services.AddScoped<ListDeliveryManifestsUseCase>();
        services.AddScoped<GetDeliveryManifestByIdUseCase>();
        services.AddScoped<RegisterProofOfDeliveryUseCase>();
        services.AddScoped<RegisterDeliveryOccurrenceUseCase>();
        services.AddScoped<ResolveDeliveryOccurrenceUseCase>();
        services.AddScoped<GetDeliveryMonitoringDashboardUseCase>();
        services.AddScoped<ListPendingDeliveriesUseCase>();
        services.AddScoped<ListDeliveriesWithOccurrenceUseCase>();
        services.AddScoped<ConfirmOrderUseCase>();
        services.AddScoped<CompletePickingTaskUseCase>();
        return services;
    }
}
