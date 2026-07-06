namespace IntegraRP.Domain.Automation;

public enum AutomationTriggerType { RecordCreated, RecordUpdated, RecordStatusChanged, TaskCreated, TaskCompleted, TaskOverdue, ProcessStarted, ProcessCompleted, OrderConfirmed, InvoiceIssued, TitleOverdue, DeliveryOccurrenceCreated, PodRegistered, KpiCritical, ScheduleDaily, ScheduleWeekly, Manual }
public enum AutomationActionType { CreateTask, StartWorkflow, UpdateRecord, UpdateStatus, SendNotification, QueueOutbox, CalculateKpi, CreateProjectCard, CallWebhookFake, OpenAiHumanEscalation, WriteAuditEvent }
public enum AutomationExecutionStatus { Pending, Running, Succeeded, Failed, Skipped, Retrying }

public sealed record AutomationRule(Guid Id, Guid TenantId, string Name, bool Enabled, int MaxRetries);
public sealed record AutomationTrigger(Guid Id, Guid TenantId, Guid RuleId, AutomationTriggerType Type, string ConfigJson);
public sealed record AutomationCondition(Guid Id, Guid TenantId, Guid RuleId, string Field, string Operator, string ExpectedValue);
public sealed record AutomationAction(Guid Id, Guid TenantId, Guid RuleId, AutomationActionType Type, string ConfigJson, int Order);
public sealed record AutomationExecution(Guid Id, Guid TenantId, Guid RuleId, AutomationExecutionStatus Status, int Attempt, DateTimeOffset CreatedAt);
public sealed record AutomationExecutionLog(Guid Id, Guid TenantId, Guid ExecutionId, string Level, string Message, DateTimeOffset CreatedAt);
