using IntegraRP.Application.Common;

namespace IntegraRP.Application.Abstractions.Notifications;

public sealed record NotificationCommand(Guid TenantId, Guid UserId, string PayloadJson);
public sealed record NotificationResult(Guid Id, string Channel, string Status);
public interface INotificationUseCases
{
    Task<Result<NotificationResult>> CreateAsync(NotificationCommand command, CancellationToken cancellationToken);
    Task<Result<NotificationResult>> SendFakeAsync(Guid notificationId, NotificationCommand command, CancellationToken cancellationToken);
    Task<Result<IReadOnlyList<NotificationResult>>> ListMineAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken);
    Task<Result<NotificationResult>> MarkAsReadAsync(Guid notificationId, NotificationCommand command, CancellationToken cancellationToken);
    Task<Result<NotificationResult>> SavePreferencesAsync(NotificationCommand command, CancellationToken cancellationToken);
}
