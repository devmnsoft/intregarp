namespace IntegraRP.Domain.Forms;

public enum FormFieldType { Text, Textarea, Number, Money, Date, Datetime, Boolean, Select, Multiselect, User, Sector, Client, Product, Order, FinancialTitle, DynamicRecord, File, Photo, Signature, Gps, Barcode, Qrcode, Rating, Checklist, Json, Relation }
public enum FormStatus { Draft, Published, Archived }

public sealed record FormDefinition(Guid Id, Guid TenantId, string Name, string? Description, FormStatus Status);
public sealed record FormVersion(Guid Id, Guid TenantId, Guid FormDefinitionId, int VersionNumber, bool Published, DateTimeOffset CreatedAt);
public sealed record FormSection(Guid Id, Guid TenantId, Guid FormVersionId, string Title, int Order);
public sealed record FormField(Guid Id, Guid TenantId, Guid SectionId, string Key, string Label, FormFieldType Type, int Order, bool Required, string? Mask, string? Regex, string? DefaultValue, string? OptionsJson, string? VisibilityJson, string? CalculationJson);
public sealed record FormRule(Guid Id, Guid TenantId, Guid FormVersionId, string Name, string TriggerJson, string ActionJson, bool Enabled);
public sealed record FormResponse(Guid Id, Guid TenantId, Guid FormVersionId, string? EntityType, Guid? EntityId, DateTimeOffset SubmittedAt);
public sealed record FormResponseField(Guid Id, Guid TenantId, Guid ResponseId, Guid FieldId, string? ValueJson);
public sealed record FormTemplate(Guid Id, Guid TenantId, string Name, string TemplateJson, bool Demo);
