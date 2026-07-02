using IntegraRP.Contracts.Connect;

namespace IntegraRP.Application.Abstractions.Connect;

public interface IConnectService
{
    Task<MessageTemplateResponse> CreateTemplateAsync(Guid tenantId, CreateMessageTemplateRequest request, CancellationToken cancellationToken);
    Task<MessageTemplateResponse> UpdateTemplateAsync(Guid tenantId, Guid id, UpdateMessageTemplateRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<MessageTemplateResponse>> ListTemplatesAsync(Guid tenantId, string? canal, CancellationToken cancellationToken);
    Task<RenderMessageTemplateResponse> RenderTemplateAsync(Guid tenantId, Guid id, RenderMessageTemplateRequest request, CancellationToken cancellationToken);
    Task<MessageDispatchResponse> SendMessageAsync(Guid tenantId, SendMessageRequest request, CancellationToken cancellationToken);
    Task<OutboxEventResponse> QueueOutboxAsync(Guid tenantId, QueueOutboxEventRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<OutboxEventResponse>> ListOutboxAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken);
    Task<OutboxEventResponse?> GetOutboxAsync(Guid tenantId, Guid id, CancellationToken cancellationToken);
    Task<OutboxEventResponse> ProcessOutboxAsync(Guid tenantId, Guid id, CancellationToken cancellationToken);
    Task<int> ProcessPendingOutboxAsync(CancellationToken cancellationToken);
    Task<ConnectDashboardResponse> GetDashboardAsync(Guid tenantId, CancellationToken cancellationToken);
    Task<IReadOnlyList<MessageDispatchResponse>> ListMessagesAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken);
}

public interface IMessageTemplateRepository { }
public interface IMessageDispatchRepository { }
public interface IConversationRepository { }
public interface IWebhookRepository { }
public interface IOutboxRepository { }
public interface IOutboxProcessingLogRepository { }
public interface IMessageTemplateRenderer { RenderMessageTemplateResponse Render(string? subject, string body, IReadOnlyDictionary<string, string> variables); }
public interface IMessageDispatcher { Task<MessageDispatchResponse> DispatchAsync(Guid tenantId, SendMessageRequest request, CancellationToken cancellationToken); }
public interface IEmailSender { }
public interface IWhatsAppSender { }
public interface ITelegramSender { }
public interface IWebhookSender { }
public interface IOutboxProcessor { Task<int> ProcessPendingAsync(CancellationToken cancellationToken); }
public interface IConnectAuditService { }
