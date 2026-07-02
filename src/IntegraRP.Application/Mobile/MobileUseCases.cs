using IntegraRP.Application.Abstractions.Mobile;
using IntegraRP.Application.Common;
using IntegraRP.Contracts.Mobile;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.Mobile;

public abstract class MobileUseCaseBase<T>(ILogger<T> logger)
{
    protected Result<TValue> Fail<TValue>(Exception ex, string operation)
    {
        logger.LogError(ex, "Erro no use case mobile {Operation}", operation);
        return Result<TValue>.Failure("Não foi possível executar a operação mobile.");
    }
}

public sealed class GetMobileDashboardUseCase(IMobileDashboardService dashboard, ILogger<GetMobileDashboardUseCase> logger) : MobileUseCaseBase<GetMobileDashboardUseCase>(logger)
{ public async Task<Result<MobileDashboardResponse>> ExecuteAsync(Guid tenantId, Guid userId, CancellationToken ct) { try { if (tenantId == Guid.Empty) return Result<MobileDashboardResponse>.Failure("Tenant obrigatório."); return Result<MobileDashboardResponse>.Success(await dashboard.GetAsync(tenantId, userId, ct)); } catch (Exception ex) { return Fail<MobileDashboardResponse>(ex, nameof(ExecuteAsync)); } } }
public sealed class ListMyMobileTasksUseCase(IMobileTaskRepository tasks, ILogger<ListMyMobileTasksUseCase> logger) : MobileUseCaseBase<ListMyMobileTasksUseCase>(logger)
{ public async Task<Result<IReadOnlyList<MobileTaskResponse>>> ExecuteAsync(Guid tenantId, Guid userId, string? filtro, int page, int pageSize, CancellationToken ct) { try { if (tenantId == Guid.Empty) return Result<IReadOnlyList<MobileTaskResponse>>.Failure("Tenant obrigatório."); return Result<IReadOnlyList<MobileTaskResponse>>.Success(await tasks.ListMyTasksAsync(tenantId, userId, filtro, page, pageSize, ct)); } catch (Exception ex) { return Fail<IReadOnlyList<MobileTaskResponse>>(ex, nameof(ExecuteAsync)); } } }
public sealed class GetMobileTaskDetailUseCase(IMobileTaskRepository tasks, ILogger<GetMobileTaskDetailUseCase> logger) : MobileUseCaseBase<GetMobileTaskDetailUseCase>(logger)
{ public async Task<Result<MobileTaskDetailResponse>> ExecuteAsync(Guid tenantId, Guid userId, Guid id, CancellationToken ct) { try { var item = await tasks.GetAsync(tenantId, userId, id, ct); return item is null ? Result<MobileTaskDetailResponse>.Failure("Tarefa não encontrada.") : Result<MobileTaskDetailResponse>.Success(item); } catch (Exception ex) { return Fail<MobileTaskDetailResponse>(ex, nameof(ExecuteAsync)); } } }
public sealed class RegisterMobileDeviceUseCase(IMobileDeviceRepository devices, ILogger<RegisterMobileDeviceUseCase> logger) : MobileUseCaseBase<RegisterMobileDeviceUseCase>(logger)
{ public async Task<Result<Guid>> ExecuteAsync(Guid tenantId, Guid userId, RegisterMobileDeviceRequest request, CancellationToken ct) { try { return Result<Guid>.Success(await devices.RegisterAsync(tenantId, userId, request, ct)); } catch (Exception ex) { return Fail<Guid>(ex, nameof(ExecuteAsync)); } } }
public sealed class CompleteMobileTaskUseCase(IMobileTaskExecutionService execution, ILogger<CompleteMobileTaskUseCase> logger) : MobileUseCaseBase<CompleteMobileTaskUseCase>(logger)
{ public async Task<Result<bool>> ExecuteAsync(Guid tenantId, Guid userId, Guid taskId, CompleteMobileTaskRequest request, CancellationToken ct) { try { return await execution.CompleteAsync(tenantId, userId, taskId, request, ct); } catch (Exception ex) { return Fail<bool>(ex, nameof(ExecuteAsync)); } } }
public sealed class UploadMobileEvidenceUseCase(IMobileEvidenceRepository evidence, ILogger<UploadMobileEvidenceUseCase> logger) : MobileUseCaseBase<UploadMobileEvidenceUseCase>(logger)
{ public async Task<Result<UploadMobileEvidenceResponse>> ExecuteAsync(Guid tenantId, Guid userId, Guid taskId, UploadMobileEvidenceRequest request, CancellationToken ct) { try { if (taskId == Guid.Empty) return Result<UploadMobileEvidenceResponse>.Failure("Evidência precisa de vínculo."); return Result<UploadMobileEvidenceResponse>.Success(await evidence.AddEvidenceAsync(tenantId, userId, taskId, request, ct)); } catch (Exception ex) { return Fail<UploadMobileEvidenceResponse>(ex, nameof(ExecuteAsync)); } } }
public sealed class CaptureMobileSignatureUseCase(IMobileEvidenceRepository evidence, ILogger<CaptureMobileSignatureUseCase> logger) : MobileUseCaseBase<CaptureMobileSignatureUseCase>(logger)
{ public async Task<Result<Guid>> ExecuteAsync(Guid tenantId, Guid userId, Guid taskId, CaptureMobileSignatureRequest request, CancellationToken ct) { try { if (string.IsNullOrWhiteSpace(request.NomeAssinante)) return Result<Guid>.Failure("Nome do assinante obrigatório."); return Result<Guid>.Success(await evidence.AddSignatureAsync(tenantId, userId, taskId, request, ct)); } catch (Exception ex) { return Fail<Guid>(ex, nameof(ExecuteAsync)); } } }
