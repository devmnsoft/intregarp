using IntegraRP.Application.FlowDesigner.UseCases;
using Microsoft.Extensions.DependencyInjection;

namespace IntegraRP.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
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
        return services;
    }
}
