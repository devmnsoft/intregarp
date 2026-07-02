using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Application.Common;
using IntegraRP.Contracts.Connect;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.Connect;

public abstract class ConnectUseCaseBase<T>(ILogger logger)
{
    protected async Task<Result<T>> RunAsync(Func<Task<T>> action)
    {
        try { return Result<T>.Success(await action()); }
        catch (Exception ex) { logger.LogError(ex, "Falha no caso de uso Connect."); return Result<T>.Failure(ex.Message); }
    }
}

public sealed class CreateMessageTemplateUseCase(IConnectService service, ILogger<CreateMessageTemplateUseCase> logger) : ConnectUseCaseBase<MessageTemplateResponse>(logger)
{ public Task<Result<MessageTemplateResponse>> ExecuteAsync(Guid tenantId, CreateMessageTemplateRequest request, CancellationToken ct) => RunAsync(() => service.CreateTemplateAsync(tenantId, request, ct)); }
public sealed class UpdateMessageTemplateUseCase(IConnectService service, ILogger<UpdateMessageTemplateUseCase> logger) : ConnectUseCaseBase<MessageTemplateResponse>(logger)
{ public Task<Result<MessageTemplateResponse>> ExecuteAsync(Guid tenantId, Guid id, UpdateMessageTemplateRequest request, CancellationToken ct) => RunAsync(() => service.UpdateTemplateAsync(tenantId, id, request, ct)); }
public sealed class ListMessageTemplatesUseCase(IConnectService service, ILogger<ListMessageTemplatesUseCase> logger) : ConnectUseCaseBase<IReadOnlyList<MessageTemplateResponse>>(logger)
{ public Task<Result<IReadOnlyList<MessageTemplateResponse>>> ExecuteAsync(Guid tenantId, string? canal, CancellationToken ct) => RunAsync(() => service.ListTemplatesAsync(tenantId, canal, ct)); }
public sealed class RenderMessageTemplateUseCase(IConnectService service, ILogger<RenderMessageTemplateUseCase> logger) : ConnectUseCaseBase<RenderMessageTemplateResponse>(logger)
{ public Task<Result<RenderMessageTemplateResponse>> ExecuteAsync(Guid tenantId, Guid id, RenderMessageTemplateRequest request, CancellationToken ct) => RunAsync(() => service.RenderTemplateAsync(tenantId, id, request, ct)); }
public sealed class SendMessageUseCase(IConnectService service, ILogger<SendMessageUseCase> logger) : ConnectUseCaseBase<MessageDispatchResponse>(logger)
{ public Task<Result<MessageDispatchResponse>> ExecuteAsync(Guid tenantId, SendMessageRequest request, CancellationToken ct) => RunAsync(() => service.SendMessageAsync(tenantId, request, ct)); }
public sealed class QueueMessageUseCase(IConnectService service, ILogger<QueueMessageUseCase> logger) : ConnectUseCaseBase<OutboxEventResponse>(logger)
{ public Task<Result<OutboxEventResponse>> ExecuteAsync(Guid tenantId, QueueMessageRequest request, CancellationToken ct) => RunAsync(() => service.QueueOutboxAsync(tenantId, new QueueOutboxEventRequest(request.TipoEvento, request.Canal, request.OrigemTipo, request.OrigemId, "normal", request.Payload), ct)); }
public sealed class ListMessageDispatchesUseCase(IConnectService service, ILogger<ListMessageDispatchesUseCase> logger) : ConnectUseCaseBase<IReadOnlyList<MessageDispatchResponse>>(logger)
{ public Task<Result<IReadOnlyList<MessageDispatchResponse>>> ExecuteAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken ct) => RunAsync(() => service.ListMessagesAsync(tenantId, status, page, pageSize, ct)); }
public sealed class RetryMessageDispatchUseCase(ILogger<RetryMessageDispatchUseCase> logger) : ConnectUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid id, RetryMessageDispatchRequest request, CancellationToken ct) => RunAsync(() => Task.FromResult("reprocessado")); }
public sealed class ListConversationsUseCase(ILogger<ListConversationsUseCase> logger) : ConnectUseCaseBase<IReadOnlyList<ConversationResponse>>(logger)
{ public Task<Result<IReadOnlyList<ConversationResponse>>> ExecuteAsync(Guid tenantId, CancellationToken ct) => RunAsync(() => Task.FromResult<IReadOnlyList<ConversationResponse>>([])); }
public sealed class AddConversationMessageUseCase(ILogger<AddConversationMessageUseCase> logger) : ConnectUseCaseBase<ConversationMessageResponse>(logger)
{ public Task<Result<ConversationMessageResponse>> ExecuteAsync(Guid tenantId, Guid conversationId, string body, CancellationToken ct) => RunAsync(() => Task.FromResult(new ConversationMessageResponse(Guid.NewGuid(), "saida", body, DateTimeOffset.UtcNow))); }
public sealed class QueueOutboxEventUseCase(IConnectService service, ILogger<QueueOutboxEventUseCase> logger) : ConnectUseCaseBase<OutboxEventResponse>(logger)
{ public Task<Result<OutboxEventResponse>> ExecuteAsync(Guid tenantId, QueueOutboxEventRequest request, CancellationToken ct) => RunAsync(() => service.QueueOutboxAsync(tenantId, request, ct)); }
public sealed class ProcessPendingOutboxUseCase(IConnectService service, ILogger<ProcessPendingOutboxUseCase> logger) : ConnectUseCaseBase<int>(logger)
{ public Task<Result<int>> ExecuteAsync(CancellationToken ct) => RunAsync(() => service.ProcessPendingOutboxAsync(ct)); }
public sealed class RetryOutboxEventUseCase(IConnectService service, ILogger<RetryOutboxEventUseCase> logger) : ConnectUseCaseBase<OutboxEventResponse>(logger)
{ public Task<Result<OutboxEventResponse>> ExecuteAsync(Guid tenantId, Guid id, RetryOutboxEventRequest request, CancellationToken ct) => RunAsync(() => service.ProcessOutboxAsync(tenantId, id, ct)); }
public sealed class CancelOutboxEventUseCase(ILogger<CancelOutboxEventUseCase> logger) : ConnectUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid id, CancellationToken ct) => RunAsync(() => Task.FromResult("cancelado")); }
public sealed class ListOutboxEventsUseCase(IConnectService service, ILogger<ListOutboxEventsUseCase> logger) : ConnectUseCaseBase<IReadOnlyList<OutboxEventResponse>>(logger)
{ public Task<Result<IReadOnlyList<OutboxEventResponse>>> ExecuteAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken ct) => RunAsync(() => service.ListOutboxAsync(tenantId, status, page, pageSize, ct)); }
public sealed class GetOutboxEventByIdUseCase(IConnectService service, ILogger<GetOutboxEventByIdUseCase> logger) : ConnectUseCaseBase<OutboxEventResponse?>(logger)
{ public Task<Result<OutboxEventResponse?>> ExecuteAsync(Guid tenantId, Guid id, CancellationToken ct) => RunAsync(() => service.GetOutboxAsync(tenantId, id, ct)); }
public sealed class GetConnectDashboardUseCase(IConnectService service, ILogger<GetConnectDashboardUseCase> logger) : ConnectUseCaseBase<ConnectDashboardResponse>(logger)
{ public Task<Result<ConnectDashboardResponse>> ExecuteAsync(Guid tenantId, CancellationToken ct) => RunAsync(() => service.GetDashboardAsync(tenantId, ct)); }
