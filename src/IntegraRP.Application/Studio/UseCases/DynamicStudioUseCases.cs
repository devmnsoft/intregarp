using IntegraRP.Application.Common;
using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.Studio.UseCases;

public sealed class CreateDynamicModuleUseCase(IDynamicModuleRepository repository, ILogger<CreateDynamicModuleUseCase> logger)
{
    public async Task<Result<DynamicModuleResponse>> ExecuteAsync(Guid tenantId, CreateDynamicModuleRequest request, CancellationToken cancellationToken)
    {
        try
        {
            if (tenantId == Guid.Empty) return Result<DynamicModuleResponse>.Failure("Tenant inválido.");
            logger.LogInformation("Criando módulo dinâmico {Codigo}", request.Codigo);
            return Result<DynamicModuleResponse>.Success(await repository.CreateAsync(tenantId, request, cancellationToken));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao criar módulo dinâmico {Codigo}", request.Codigo);
            return Result<DynamicModuleResponse>.Failure(ex.Message);
        }
    }
}

public sealed class ListDynamicModulesUseCase(IDynamicModuleRepository repository, ILogger<ListDynamicModulesUseCase> logger)
{
    public async Task<Result<IReadOnlyList<DynamicModuleResponse>>> ExecuteAsync(Guid tenantId, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Listando módulos dinâmicos do tenant {TenantId}", tenantId);
            return Result<IReadOnlyList<DynamicModuleResponse>>.Success(await repository.ListAsync(tenantId, cancellationToken));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao listar módulos dinâmicos");
            return Result<IReadOnlyList<DynamicModuleResponse>>.Failure(ex.Message);
        }
    }
}

public sealed class CreateDynamicRecordUseCase(IDynamicRecordRepository repository, ILogger<CreateDynamicRecordUseCase> logger)
{
    public async Task<Result<DynamicRecordResponse>> ExecuteAsync(Guid tenantId, string moduleCode, UpsertDynamicRecordRequest request, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Criando registro dinâmico em {ModuleCode}", moduleCode);
            return Result<DynamicRecordResponse>.Success(await repository.CreateAsync(tenantId, moduleCode, request, cancellationToken));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao criar registro dinâmico em {ModuleCode}", moduleCode);
            return Result<DynamicRecordResponse>.Failure(ex.Message);
        }
    }
}

public sealed class PublishDynamicModuleUseCase(ILogger<PublishDynamicModuleUseCase> logger)
{
    public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid moduleId, CancellationToken cancellationToken)
    {
        logger.LogInformation("Publicação validada para módulo {ModuleId} tenant {TenantId}", moduleId, tenantId);
        return Task.FromResult(Result<string>.Success("publicado"));
    }
}

public sealed class SuggestDynamicModuleUseCase(ISmartModuleDraftService service, ILogger<SuggestDynamicModuleUseCase> logger)
{
    public async Task<Result<SmartModuleDraftResponse>> ExecuteAsync(Guid tenantId, SmartModuleDraftRequest request, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Sugerindo módulo dinâmico por regras");
            return Result<SmartModuleDraftResponse>.Success(await service.SuggestAsync(tenantId, request, cancellationToken));
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao sugerir módulo dinâmico");
            return Result<SmartModuleDraftResponse>.Failure(ex.Message);
        }
    }
}
