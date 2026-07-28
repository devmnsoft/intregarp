using IntegraRP.Contracts.Commercial;

namespace IntegraRP.Application.Commercial;

public interface INotificationRepository
{
    Task<NotificationPageDto> ListAsync(Guid tenantId, Guid userId, int page, int pageSize, CancellationToken ct);
    Task<int> GetUnreadCountAsync(Guid tenantId, Guid userId, CancellationToken ct);
    Task<NotificationDto> MarkReadAsync(Guid tenantId, Guid userId, Guid notificationId, CancellationToken ct);
    Task<int> MarkAllReadAsync(Guid tenantId, Guid userId, CancellationToken ct);
    Task<NotificationDto> CreateAsync(Guid tenantId, CreateNotificationRequest request, string correlationId, CancellationToken ct);
}

public sealed class ListNotificationsUseCase(INotificationRepository repository) { public Task<NotificationPageDto> ExecuteAsync(Guid tenantId, Guid userId, int page, int size, CancellationToken ct) => repository.ListAsync(tenantId, userId, page, Math.Clamp(size, 1, 100), ct); }
public sealed class GetUnreadNotificationCountUseCase(INotificationRepository repository) { public Task<int> ExecuteAsync(Guid tenantId, Guid userId, CancellationToken ct) => repository.GetUnreadCountAsync(tenantId, userId, ct); }
public sealed class MarkNotificationReadUseCase(INotificationRepository repository) { public Task<NotificationDto> ExecuteAsync(Guid tenantId, Guid userId, Guid id, CancellationToken ct) => repository.MarkReadAsync(tenantId, userId, id, ct); }
public sealed class MarkAllNotificationsReadUseCase(INotificationRepository repository) { public Task<int> ExecuteAsync(Guid tenantId, Guid userId, CancellationToken ct) => repository.MarkAllReadAsync(tenantId, userId, ct); }
public sealed class CreateNotificationUseCase(INotificationRepository repository) { public Task<NotificationDto> ExecuteAsync(Guid tenantId, CreateNotificationRequest request, string correlationId, CancellationToken ct) => repository.CreateAsync(tenantId, request, correlationId, ct); }
