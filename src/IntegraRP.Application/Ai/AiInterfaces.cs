using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;

namespace IntegraRP.Application.Ai;

public interface IAiOrchestrator { Task<AiChatResponse> ChatAsync(Guid tenantId, AiChatRequest request, CancellationToken cancellationToken); }
public interface IAiIntentClassifier { string Classify(string message); }
public interface IAiPermissionValidator { bool CanUseTool(IReadOnlyCollection<string> permissions, string toolCode); }
public interface IAiToolRegistry { IReadOnlyList<IAiTool> Tools { get; } IAiTool? Find(string intent); }
public interface IAiTool { string Code { get; } string Name { get; } string RequiredPermission { get; } Task<string> ExecuteAsync(Guid tenantId, string message, CancellationToken cancellationToken); }
public interface IAiResponseGenerator { string Generate(string intent, string toolResult, bool masked); }
public interface IAiAuditService { Task RegisterAsync(Guid tenantId, string intent, string toolCode, string question, string response, CancellationToken cancellationToken); }
public interface IHumanEscalationService { Task<Guid> OpenAsync(Guid tenantId, string reason, CancellationToken cancellationToken); }
public interface IAiDataMaskingService { string Mask(string value); }
public interface IAiConversationRepository { Task<Guid> CreateAsync(Guid tenantId, string channel, CancellationToken cancellationToken); }
public interface IAiProvider { Task<string> CompleteAsync(string prompt, CancellationToken cancellationToken); }
