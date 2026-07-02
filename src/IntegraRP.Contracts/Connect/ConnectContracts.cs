namespace IntegraRP.Contracts.Connect;

public sealed record MessageTemplateResponse(Guid Id, Guid? TenantId, string Codigo, string Nome, string Canal, string Categoria, string? AssuntoTemplate, string CorpoTemplate, bool Ativo, bool Publico);
public sealed record CreateMessageTemplateRequest(string Codigo, string Nome, string Canal, string Categoria, string? AssuntoTemplate, string CorpoTemplate, bool Publico);
public sealed record UpdateMessageTemplateRequest(string Nome, string Categoria, string? AssuntoTemplate, string CorpoTemplate, bool Ativo, bool Publico);
public sealed record RenderMessageTemplateRequest(Dictionary<string, string> Variaveis);
public sealed record RenderMessageTemplateResponse(string? Assunto, string Corpo, IReadOnlyList<string> Warnings);
public sealed record SendMessageRequest(string Canal, string Destinatario, string? Assunto, string Corpo, string? OrigemTipo, Guid? OrigemId);
public sealed record QueueMessageRequest(string TipoEvento, string Canal, string OrigemTipo, Guid? OrigemId, Dictionary<string, object?> Payload);
public sealed record MessageDispatchResponse(Guid Id, Guid TenantId, string Canal, string Status, string? Assunto, string Corpo, string? Erro, int Tentativas, DateTimeOffset? EnviadoEm);
public sealed record RetryMessageDispatchRequest(string? Motivo);
public sealed record OutboxEventResponse(Guid Id, Guid TenantId, string TipoEvento, string? Canal, string? OrigemTipo, Guid? OrigemId, string Prioridade, string Status, int Tentativas, int MaxTentativas, string? Erro, DateTimeOffset CriadoEm);
public sealed record QueueOutboxEventRequest(string TipoEvento, string? Canal, string? OrigemTipo, Guid? OrigemId, string Prioridade, Dictionary<string, object?> Payload);
public sealed record RetryOutboxEventRequest(string? Motivo);
public sealed record ConnectDashboardResponse(int MensagensPendentes, int MensagensEnviadas, int MensagensComErro, int OutboxPendente, int OutboxProcessado, int OutboxComErro, double TempoMedioProcessamentoSegundos, double TentativasMediasPorMensagem);
public sealed record ConversationResponse(Guid Id, Guid TenantId, string Canal, string Status, IReadOnlyList<ConversationMessageResponse> Mensagens);
public sealed record ConversationMessageResponse(Guid Id, string Direcao, string Corpo, DateTimeOffset CriadoEm);
