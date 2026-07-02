namespace IntegraRP.Contracts.Responses;

public sealed record FlowProcessResponse(Guid Id, string Nome, string Codigo, string Status, IReadOnlyList<string> Etapas);
public sealed record FlowInstanceResponse(Guid Id, Guid ProcessoId, string Status, DateTimeOffset CriadoEm);
public sealed record WorkflowTaskResponse(Guid Id, string Titulo, string Status, string Prioridade, string Responsavel);
public sealed record DynamicModuleResponse(Guid Id, string Nome, string Codigo, string Icone, string Cor, IReadOnlyList<DynamicFieldResponse> Campos);
public sealed record DynamicFieldResponse(string Nome, string Codigo, string Tipo, bool Obrigatorio);
public sealed record DynamicActionResponse(string Nome, string Codigo, string Tipo);
public sealed record SmartModuleDraftResponse(string Nome, string Icone, string Cor, string EntidadePrincipal, IReadOnlyList<DynamicFieldResponse> Campos, IReadOnlyList<DynamicActionResponse> Acoes, IReadOnlyList<string> Kpis, string BpmnSugerido);
public sealed record DynamicRecordResponse(Guid Id, string ModuleCode, Dictionary<string, object?> Valores);
public sealed record AiChatResponse(Guid ConversaId, string Intencao, string Resposta, bool EscaladoHumano, decimal Confianca);
public sealed record AiToolResponse(string Codigo, string Nome, bool Governada);
