using IntegraRP.Application.Common;
using IntegraRP.Contracts.Mobile;

namespace IntegraRP.Application.Abstractions.Mobile;

public interface IMobileDeviceRepository { Task<Guid> RegisterAsync(Guid tenantId, Guid usuarioId, RegisterMobileDeviceRequest request, CancellationToken cancellationToken); }
public interface IMobileTaskRepository { Task<IReadOnlyList<MobileTaskResponse>> ListMyTasksAsync(Guid tenantId, Guid usuarioId, string? filtro, int page, int pageSize, CancellationToken cancellationToken); Task<MobileTaskDetailResponse?> GetAsync(Guid tenantId, Guid usuarioId, Guid taskId, CancellationToken cancellationToken); Task SaveStatusAsync(Guid tenantId, Guid usuarioId, Guid taskId, string status, CancellationToken cancellationToken); }
public interface IMobileEvidenceRepository { Task<UploadMobileEvidenceResponse> AddEvidenceAsync(Guid tenantId, Guid usuarioId, Guid taskId, UploadMobileEvidenceRequest request, CancellationToken cancellationToken); Task<Guid> AddSignatureAsync(Guid tenantId, Guid usuarioId, Guid taskId, CaptureMobileSignatureRequest request, CancellationToken cancellationToken); }
public interface IMobileNotificationRepository { Task<IReadOnlyList<MobileNotificationResponse>> ListAsync(Guid tenantId, Guid usuarioId, CancellationToken cancellationToken); Task MarkReadAsync(Guid tenantId, Guid usuarioId, Guid notificationId, CancellationToken cancellationToken); }
public interface IMobileSyncRepository { Task QueueAsync(Guid tenantId, Guid usuarioId, MobileSyncQueueRequest request, CancellationToken cancellationToken); Task<MobileSyncStatusResponse> GetStatusAsync(Guid tenantId, Guid usuarioId, CancellationToken cancellationToken); }
public interface IMobileStorageService { Task<string> SaveAsync(Guid tenantId, string? base64Content, string? contentType, CancellationToken cancellationToken); }
public interface IMobileDashboardService { Task<MobileDashboardResponse> GetAsync(Guid tenantId, Guid usuarioId, CancellationToken cancellationToken); }
public interface IMobileTaskExecutionService { Task<Result<Guid>> StartAsync(Guid tenantId, Guid usuarioId, Guid taskId, StartMobileTaskExecutionRequest request, CancellationToken cancellationToken); Task<Result<bool>> CompleteAsync(Guid tenantId, Guid usuarioId, Guid taskId, CompleteMobileTaskRequest request, CancellationToken cancellationToken); }
public interface IMobileApprovalService { Task<Result<bool>> DecideAsync(Guid tenantId, Guid usuarioId, Guid taskId, bool approved, string comentario, CancellationToken cancellationToken); }
