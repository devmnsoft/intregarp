using IntegraRP.Contracts.Ai;

namespace IntegraRP.Application.Abstractions.Ai;

public sealed record AiIntentClassification(string IntentCode, string? ToolCode, decimal Confidence);
public sealed record AiToolExecutionContext(Guid TenantId, Guid? UserId, IReadOnlyCollection<string> Permissions, string Message);
public sealed record AiToolExecutionResult(string Response, string DataJson, decimal Confidence, bool Masked);
public interface IAiOrchestratorV2 { Task<SendAiMessageResponse> SendAsync(Guid tenantId, Guid? userId, Guid conversationId, SendAiMessageRequest request, CancellationToken cancellationToken); }
public interface IAiIntentClassifierV2 { AiIntentClassification Classify(string message); }
public interface IAiPermissionValidatorV2 { bool HasPermission(IReadOnlyCollection<string> permissions, string? permission); }
public interface IAiToolRegistryV2 { IReadOnlyList<IAiToolV2> Tools { get; } IAiToolV2? Find(string toolCode); }
public interface IAiToolV2 { string Code { get; } string Description { get; } string RequiredPermission { get; } Task<AiToolExecutionResult> ExecuteAsync(AiToolExecutionContext context, CancellationToken cancellationToken); }
public interface IAiResponseGeneratorV2 { string Generate(AiIntentClassification intent, AiToolExecutionResult result); }
public interface IAiAuditServiceV2 { Task<Guid> RegisterAsync(Guid tenantId, Guid? userId, string question, AiIntentClassification intent, string response, string status, CancellationToken cancellationToken); }
public interface IAiConversationRepositoryV2 { Task<Guid> StartAsync(Guid tenantId, Guid? userId, StartAiConversationRequest request, CancellationToken cancellationToken); Task<IReadOnlyList<AiConversationResponse>> ListAsync(Guid tenantId, Guid? userId, int page, int pageSize, CancellationToken cancellationToken); }
public interface IAiHumanEscalationServiceV2 { Task<Guid> OpenAsync(Guid tenantId, Guid? userId, Guid? conversationId, string reason, string? description, CancellationToken cancellationToken); }
public interface IAiDataMaskingServiceV2 { string MaskFinancial(string value, bool canSeeSensitive); string MaskGeo(decimal? lat, decimal? lng, bool canSeePrecise); }
public interface IAiContextBuilder { Task<object> BuildAsync(Guid tenantId, Guid? userId, CancellationToken cancellationToken); }
public interface IAiProvider { Task<string> CompleteAsync(string prompt, CancellationToken cancellationToken); }
public interface IAiFeedbackService { Task<AiFeedbackResponse> AddAsync(Guid tenantId, Guid? userId, AddAiUserFeedbackRequest request, CancellationToken cancellationToken); }
