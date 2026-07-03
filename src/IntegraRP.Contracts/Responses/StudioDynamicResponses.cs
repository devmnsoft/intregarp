namespace IntegraRP.Contracts.Responses;

public sealed record DynamicModuleDetailResponse(Guid Id, string Nome, string Codigo, string Status, IReadOnlyList<DynamicFieldResponse> Campos, IReadOnlyList<DynamicActionResponse> Acoes);
public sealed record ExportDynamicModuleResponse(string Json, DateTimeOffset ExportadoEm);
public sealed record DynamicEntityResponse(Guid Id, string Nome, string Codigo, bool EntidadePrincipal);
public sealed record DynamicMenuResponse(Guid ModuleId, string MenuPath, bool VisivelWeb, bool VisivelMobile);
public sealed record DynamicRelationshipResponse(Guid Id, string Codigo, string Tipo, string DestinoTipo, string DestinoCodigo);
public sealed record DynamicBpmnBindingResponse(Guid Id, string Evento, Guid? ProcessoId, string ProcessoNome, string? AcaoCodigo);
public sealed record DynamicKpiResponse(Guid Id, string Nome, string Codigo, string Tipo, decimal? Valor);
public sealed record DynamicSemanticCatalogResponse(Guid ModuleId, string Descricao, IReadOnlyList<string> PerguntasPermitidas, IReadOnlyList<string> CamposProibidos, bool ExigirPermissao);
public sealed record SuggestDynamicModuleResponse(string Nome, string Codigo, string Icone, string Cor, string EntidadePrincipal, IReadOnlyList<DynamicFieldResponse> Campos, IReadOnlyList<DynamicActionResponse> Acoes, IReadOnlyList<string> Kpis, string BpmnSugerido, DynamicSemanticCatalogResponse CatalogoSemantico);
public sealed record DynamicRecordDetailResponse(Guid Id, string ModuleCode, string? Titulo, string Status, Dictionary<string, object?> Valores, IReadOnlyList<DynamicRecordHistoryResponse> Historico);
public sealed record DynamicRecordValueResponse(string CampoCodigo, string Tipo, object? Valor, bool Mascarado);
public sealed record DynamicRecordHistoryResponse(Guid Id, Guid RecordId, string Evento, DateTimeOffset CriadoEm, string Resumo);
public sealed record DynamicRecordCommentResponse(Guid Id, Guid RecordId, string Comentario, DateTimeOffset CriadoEm);
public sealed record DynamicRecordAttachmentResponse(Guid Id, Guid RecordId, string NomeArquivo, string ContentType, long TamanhoBytes, string Url);
public sealed record ExecuteDynamicActionResponse(Guid LogId, string Status, string Mensagem, Guid? ProcessoInstanciaId);
