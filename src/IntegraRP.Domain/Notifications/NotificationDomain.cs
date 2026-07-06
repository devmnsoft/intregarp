namespace IntegraRP.Domain.Notifications;

public enum NotificationChannel { Sistema, EmailFake, WhatsappFake, TelegramFake, MobilePushFake, WebhookFake }
public sealed record Notification(Guid Id, Guid TenantId, string EventCode, string Title, string Body, DateTimeOffset CreatedAt);
public sealed record NotificationRecipient(Guid Id, Guid TenantId, Guid NotificationId, Guid UserId, bool Read, DateTimeOffset? ReadAt);
public sealed record NotificationPreference(Guid Id, Guid TenantId, Guid UserId, NotificationChannel Channel, bool Enabled);
public sealed record NotificationTemplate(Guid Id, Guid TenantId, string EventCode, NotificationChannel Channel, string SubjectTemplate, string BodyTemplate);
public sealed record NotificationPushLog(Guid Id, Guid TenantId, Guid NotificationId, NotificationChannel Channel, string Status, string? Error, DateTimeOffset CreatedAt);
