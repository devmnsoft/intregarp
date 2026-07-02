namespace IntegraRP.Contracts.Requests;

public sealed record CreateProcessRequest(string Nome, string Codigo, IReadOnlyList<ProcessStepRequest> Etapas);
public sealed record ProcessStepRequest(string Nome, string Tipo, string? Responsavel, int? SlaHoras, string? Condicao);
public sealed record CreateProcessVersionRequest(string Nome, string JsonDefinition);
public sealed record StartProcessRequest(Guid? OrigemId, string TriggerType, string PayloadJson);
public sealed record CompleteTaskRequest(string Resultado, string? Comentario);
public sealed record CreateDynamicModuleRequest(string Nome, string Codigo, string Icone, string Cor);
public sealed record CreateDynamicFieldRequest(string Nome, string Codigo, string Tipo, bool Obrigatorio);
public sealed record CreateDynamicActionRequest(string Nome, string Codigo, string Tipo);
public sealed record SmartModuleDraftRequest(string Descricao);
public sealed record UpsertDynamicRecordRequest(Dictionary<string, object?> Valores);
public sealed record AiChatRequest(string Mensagem, string Canal, IReadOnlyCollection<string> Permissoes);
