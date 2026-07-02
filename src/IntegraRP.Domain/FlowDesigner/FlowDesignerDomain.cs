namespace IntegraRP.Domain.FlowDesigner;

public enum FlowTemplateCategory { OperacaoComercial, Financeiro, AdministrativoFinanceiro, Marketing, Vendas, TradeMarketing, Logistica }
public enum FlowDesignerActionType { TemplateCloned, ElementCreated, ElementUpdated, ElementDeleted, TransitionCreated, TransitionUpdated, TransitionDeleted, LayoutSaved, FormSaved, ChecklistSaved, VersionValidated, VersionPublished }
public enum FlowDesignerIssueSeverity { Error, Warning, Info }
public enum FlowDesignerIssueCode { MissingStartEvent, MissingEndEvent, DuplicateElementCode, InvalidTransition, OrphanElement, GatewayInvalid, HumanTaskWithoutOwner, InvalidFormField, InvalidChecklistItem, PublishedVersionLocked }

public sealed record FlowTemplateCode(string Value) { public FlowTemplateCode() : this(string.Empty) { } }
public sealed record DesignerPosition(decimal X, decimal Y);
public sealed record DesignerColor(string Value);
public sealed record FlowTemplate(Guid Id, Guid? TenantId, FlowTemplateCode Code, string Name, string Category, IReadOnlyList<FlowTemplateElement> Elements, IReadOnlyList<FlowTemplateTransition> Transitions);
public sealed record FlowTemplateElement(Guid Id, string Code, string Name, string Type, string? SuggestedSector, int? SlaMinutes, DesignerPosition Position);
public sealed record FlowTemplateTransition(Guid Id, string Code, string SourceCode, string TargetCode, string ConditionType);
public sealed record FlowDesignerHistory(Guid Id, Guid TenantId, Guid ProcessDefinitionId, Guid ProcessVersionId, Guid? UserId, FlowDesignerActionType Action, string? Description, DateTimeOffset CreatedAt);
public sealed record FlowDesignerValidationResult(IReadOnlyList<FlowDesignerValidationIssue> Issues) { public bool CanPublish => Issues.All(x => x.Severity != FlowDesignerIssueSeverity.Error); }
public sealed record FlowDesignerValidationIssue(FlowDesignerIssueSeverity Severity, FlowDesignerIssueCode Code, string Message, Guid? ElementId = null, Guid? TransitionId = null);
