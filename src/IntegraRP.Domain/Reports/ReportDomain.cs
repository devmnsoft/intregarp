namespace IntegraRP.Domain.Reports;

public enum ReportFormat { Csv, Xlsx, PdfHtml, Json }
public enum ReportExecutionStatus { Pending, Running, Succeeded, Failed }
public sealed record ReportDefinition(Guid Id, Guid TenantId, string Name, string QueryKey, bool Enabled);
public sealed record ReportFilter(Guid Id, Guid TenantId, Guid ReportDefinitionId, string Name, string Type, bool Required);
public sealed record ReportExecution(Guid Id, Guid TenantId, Guid ReportDefinitionId, ReportExecutionStatus Status, DateTimeOffset CreatedAt);
public sealed record ReportExport(Guid Id, Guid TenantId, Guid ExecutionId, ReportFormat Format, string StorageKey, DateTimeOffset ExpiresAt);
public sealed record ReportSchedule(Guid Id, Guid TenantId, Guid ReportDefinitionId, string CronExpression, ReportFormat Format, bool Enabled);
