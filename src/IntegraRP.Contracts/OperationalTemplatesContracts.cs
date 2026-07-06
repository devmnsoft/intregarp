namespace IntegraRP.Contracts.OperationalTemplates;

public sealed record OperationalTemplatePackageResponse(Guid Id, Guid? TenantId, string Codigo, string Nome, string? Descricao, string? Segmento, string Versao, bool Publico, bool Ativo, string? Icone, string Cor);
public sealed record OperationalTemplateResponse(Guid Id, Guid? PackageId, Guid? TenantId, string Codigo, string Nome, string? Descricao, string Categoria, string Tipo, string? SetorSugerido, string? Icone, string Cor, bool Ativo, string TemplateJson);
public sealed record OperationalTemplatePreviewRequest(Guid TenantId, IReadOnlyDictionary<string, string>? Variaveis);
public sealed record OperationalTemplatePreviewResponse(Guid TemplateId, string Nome, IReadOnlyList<string> ObjetosPrevistos, IReadOnlyList<string> Permissoes, IReadOnlyList<string> Avisos);
public sealed record InstallOperationalTemplateRequest(Guid TenantId, Guid? UsuarioId, IReadOnlyDictionary<string, string>? Configuracao);
public sealed record InstallOperationalTemplateResponse(Guid InstallationId, string Status, IReadOnlyList<string> ObjetosCriados, string Mensagem);
public sealed record OperationalTemplateInstallationResponse(Guid Id, Guid TenantId, Guid? TemplateId, Guid? PackageId, string Status, DateTimeOffset CriadoEm, DateTimeOffset? InstaladoEm, string? Erro);
public sealed record OperationalTemplateInstallationLogResponse(Guid Id, Guid InstallationId, string Etapa, string Status, string Mensagem, DateTimeOffset CriadoEm);
