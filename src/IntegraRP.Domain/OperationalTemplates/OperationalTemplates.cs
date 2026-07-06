namespace IntegraRP.Domain.OperationalTemplates;

public enum OperationalTemplateCategory { Avarias, Devolucoes, Romaneio, Roteirizacao, Entrega, VisitaVendedor, VisitaPromotor, PontoVenda, EstoqueCampo, Satisfacao }
public enum OperationalTemplateType { ModuloDinamico, ProcessoBpmn, Kpi, Dashboard, Mensagem, AiCatalogo, MobileForm, Pacote }
public enum OperationalTemplateInstallationStatus { Pendente, Instalado, Parcial, Erro, Removido }

public sealed record OperationalTemplateCode
{
    public OperationalTemplateCode(string value)
    {
        Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Código obrigatório.") : value.Trim();
    }

    public string Value { get; }
}
public sealed record OperationalTemplatePackage(Guid Id, Guid? TenantId, OperationalTemplateCode Codigo, string Nome, string? Descricao, string Versao, bool Publico, bool Ativo);
public sealed record OperationalTemplate(Guid Id, Guid? PackageId, Guid? TenantId, OperationalTemplateCode Codigo, string Nome, string? Descricao, OperationalTemplateCategory Categoria, OperationalTemplateType Tipo, string TemplateJson, bool Ativo);
public sealed record OperationalTemplateItem(Guid Id, Guid TemplateId, string Tipo, string Codigo, string Nome, string PayloadJson);
public sealed record OperationalTemplateInstallation(Guid Id, Guid TenantId, Guid? TemplateId, Guid? PackageId, OperationalTemplateInstallationStatus Status, DateTimeOffset CriadoEm, DateTimeOffset? InstaladoEm, string? Erro);
public sealed record OperationalTemplateInstallationLog(Guid Id, Guid InstallationId, string Etapa, string Status, string Mensagem, DateTimeOffset CriadoEm);
public sealed record OperationalTemplateDependency(Guid Id, Guid TemplateId, string CodigoDependencia, bool Obrigatoria);
public sealed record OperationalTemplateVariable(Guid Id, Guid TemplateId, string Codigo, string Nome, bool Obrigatoria);
public sealed record OperationalTemplateKpi(Guid Id, Guid TemplateId, string Codigo, string Nome, string Unidade);
public sealed record OperationalTemplateAiCatalog(Guid Id, Guid TemplateId, string Intent, string Descricao);
public sealed record OperationalTemplateMessage(Guid Id, Guid TemplateId, string Codigo, string Canal, string Conteudo);
public sealed record OperationalTemplateDashboard(Guid Id, Guid TemplateId, string Codigo, string WidgetJson);
