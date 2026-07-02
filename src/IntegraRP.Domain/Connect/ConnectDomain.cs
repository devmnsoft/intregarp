namespace IntegraRP.Domain.Connect;

public enum MessageChannel { Email, Whatsapp, Telegram, Sistema, Webhook }
public enum MessageDispatchStatus { Pendente, Processando, Enviado, Erro, Cancelado }
public enum OutboxStatus { Pendente, Processando, Processado, Erro, Cancelado }
public enum OutboxPriority { Baixa, Normal, Alta, Critica }
public enum WebhookStatus { Ativo, Inativo, Erro }

public readonly record struct MessageTemplateCode
{
    public string Value { get; }
    public MessageTemplateCode(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) throw new ArgumentException("Código do template é obrigatório.", nameof(value));
        Value = value.Trim();
    }
}

public readonly record struct MessageRecipient
{
    public string Address { get; }
    public MessageRecipient(string address)
    {
        if (string.IsNullOrWhiteSpace(address)) throw new ArgumentException("Destinatário é obrigatório.", nameof(address));
        Address = address.Trim();
    }
}

public readonly record struct RenderedMessage(string Subject, string Body);

public sealed class MessageTemplate
{
    public Guid Id { get; } = Guid.NewGuid();
    public Guid? TenantId { get; }
    public string Code { get; }
    public string Name { get; }
    public MessageChannel Channel { get; }
    public string BodyTemplate { get; }

    public MessageTemplate(Guid? tenantId, string code, string name, MessageChannel channel, string bodyTemplate)
    {
        if (string.IsNullOrWhiteSpace(bodyTemplate)) throw new ArgumentException("Template precisa ter corpo.", nameof(bodyTemplate));
        TenantId = tenantId;
        Code = new MessageTemplateCode(code).Value;
        Name = string.IsNullOrWhiteSpace(name) ? Code : name.Trim();
        Channel = channel;
        BodyTemplate = bodyTemplate;
    }
}

public sealed class OutboxEvent
{
    public Guid Id { get; } = Guid.NewGuid();
    public Guid TenantId { get; }
    public string EventType { get; }
    public OutboxStatus Status { get; private set; } = OutboxStatus.Pendente;
    public int Attempts { get; private set; }
    public int MaxAttempts { get; }

    public OutboxEvent(Guid tenantId, string eventType, int maxAttempts = 5)
    {
        TenantId = tenantId == Guid.Empty ? throw new ArgumentException("Tenant é obrigatório.", nameof(tenantId)) : tenantId;
        EventType = string.IsNullOrWhiteSpace(eventType) ? throw new ArgumentException("Tipo do evento é obrigatório.", nameof(eventType)) : eventType.Trim();
        MaxAttempts = maxAttempts;
    }

    public bool CanRetryAutomatically() => Status == OutboxStatus.Erro && Attempts < MaxAttempts;
    public void MarkError() { Attempts++; Status = OutboxStatus.Erro; }
    public void MarkProcessed() => Status = OutboxStatus.Processado;
    public void Cancel() => Status = OutboxStatus.Cancelado;
}

public sealed record MessageDispatch(Guid Id, Guid TenantId, MessageChannel Channel, MessageDispatchStatus Status, string Body, string? Subject);
public sealed record MessageDispatchRecipient(Guid Id, Guid DispatchId, string Address, string? Name);
public sealed record ConversationChannel(Guid Id, Guid TenantId, MessageChannel Channel, string Status);
public sealed record ConversationMessage(Guid Id, Guid ConversationId, string Direction, string Body, DateTimeOffset CreatedAt);
public sealed record WebhookEndpoint(Guid Id, Guid TenantId, string Url, WebhookStatus Status);
public sealed record WebhookEvent(Guid Id, Guid TenantId, Guid EndpointId, string Status, string PayloadJson);
public sealed record ConnectConfiguration(Guid TenantId, bool FakeProvidersEnabled);
public sealed record OutboxProcessingLog(Guid Id, Guid OutboxEventId, string Status, string? Error, DateTimeOffset CreatedAt);
