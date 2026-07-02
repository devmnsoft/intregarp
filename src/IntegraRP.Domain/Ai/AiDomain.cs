namespace IntegraRP.Domain.Ai;

public enum AiConversationStatus { Aberta, Encerrada }
public enum AiMessageRole { User, Assistant, System, Tool }
public enum AiChannel { Web, Mobile, Whatsapp, Sistema }
public enum AiAuditStatus { Permitido, Negado, FallbackHumano, Erro }
public enum AiConfidenceLevel { Baixa, Media, Alta }
public enum AiHumanEscalationStatus { Aberto, EmAtendimento, Resolvido, Cancelado }
public sealed record AiToolCode(string Value);
public sealed record AiIntentCode(string Value);
public sealed record AiConfidence(decimal Value) { public AiConfidenceLevel Level => Value < 0.5m ? AiConfidenceLevel.Baixa : Value < 0.8m ? AiConfidenceLevel.Media : AiConfidenceLevel.Alta; }
public sealed record MaskedValue(string Value, bool Masked);
public sealed record AiAgent(Guid Id, Guid? TenantId, string Codigo, string Nome, bool Ativo);
public sealed record AiIntent(Guid Id, Guid? TenantId, AiIntentCode Codigo, string Nome, string? FerramentaPadraoCodigo, bool Ativo);
public sealed record AiToolDefinition(Guid Id, Guid? TenantId, AiToolCode Codigo, string Nome, string Modulo, string? RequerPermissao, bool Ativo);
public sealed record AiToolPermission(Guid Id, Guid? TenantId, string ToolCode, string Permission);
public sealed record AiConversation(Guid Id, Guid TenantId, Guid? UsuarioId, AiChannel Canal, AiConversationStatus Status, DateTimeOffset CriadoEm);
public sealed record AiMessage(Guid Id, Guid TenantId, Guid ConversaId, AiMessageRole Papel, string Conteudo, AiIntentCode? Intencao, AiToolCode? Ferramenta, AiConfidence? Confianca);
public sealed record AiAuditEvent(Guid Id, Guid TenantId, AiAuditStatus Status, string? Pergunta, string? Resposta, AiConfidence? Confianca);
public sealed record AiHumanEscalation(Guid Id, Guid TenantId, Guid? ConversaId, string Motivo, AiHumanEscalationStatus Status);
public sealed record AiAllowedContext(Guid Id, Guid? TenantId, string Codigo, string Escopo);
public sealed record AiUserFeedback(Guid Id, Guid TenantId, Guid ConversaId, int Nota, string? Comentario);
public sealed record AiConfiguration(Guid Id, Guid? TenantId, string Chave, string ValorJson);
