namespace IntegraRP.Contracts.Ai;

public sealed record StartAiConversationRequest(string Canal, string? Titulo);
public sealed record AiConversationResponse(Guid Id, string Canal, string? Titulo, string Status, DateTimeOffset CriadoEm, IReadOnlyList<AiMessageResponse> Mensagens);
public sealed record AiMessageResponse(Guid Id, string Papel, string Conteudo, string? IntencaoCodigo, string? FerramentaCodigo, decimal? Confianca, DateTimeOffset CriadoEm);
public sealed record SendAiMessageRequest(string Mensagem, string Canal, IReadOnlyCollection<string>? Permissoes);
public sealed record SendAiMessageResponse(Guid ConversaId, Guid MensagemId, string Resposta, string IntencaoCodigo, string? FerramentaCodigo, decimal Confianca, bool FallbackHumano, Guid? EscalonamentoHumanoId);
public sealed record AiToolResponse(string Codigo, string Nome, string Descricao, string Modulo, string? Permissao, bool Ativa);
public sealed record AiAuditResponse(Guid Id, string? Canal, string? IntencaoCodigo, string? FerramentaCodigo, string Status, decimal? Confianca, DateTimeOffset CriadoEm);
public sealed record AiAuditDetailResponse(Guid Id, string? Pergunta, string? Resposta, string? IntencaoCodigo, string? FerramentaCodigo, bool PermissaoValidada, bool EscopoValidado, bool MascaramentoAplicado, string DadosConsultadosJson, string Status, string? Motivo, DateTimeOffset CriadoEm);
public sealed record AiHumanEscalationResponse(Guid Id, Guid? ConversaId, string Motivo, string? Descricao, string Status, DateTimeOffset CriadoEm);
public sealed record ResolveAiHumanEscalationRequest(string Comentario);
public sealed record AddAiUserFeedbackRequest(Guid ConversaId, Guid? MensagemId, int Nota, string? Comentario);
public sealed record AiFeedbackResponse(Guid Id, int Nota, string Status);
