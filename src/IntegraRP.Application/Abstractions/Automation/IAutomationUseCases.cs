using IntegraRP.Application.Common;

namespace IntegraRP.Application.Abstractions.Automation;

public sealed record AutomationCommand(Guid TenantId, Guid UserId, string PayloadJson);
public sealed record AutomationResult(Guid Id, string Status, string PayloadJson);
public interface IAutomationUseCases
{
    Task<Result<AutomationResult>> CreateRuleAsync(AutomationCommand command, CancellationToken cancellationToken);
    Task<Result<AutomationResult>> UpdateRuleAsync(Guid ruleId, AutomationCommand command, CancellationToken cancellationToken);
    Task<Result<AutomationResult>> SetEnabledAsync(Guid ruleId, bool enabled, AutomationCommand command, CancellationToken cancellationToken);
    Task<Result<AutomationResult>> ExecuteAsync(Guid ruleId, AutomationCommand command, CancellationToken cancellationToken);
    Task<Result<IReadOnlyList<AutomationResult>>> ListExecutionsAsync(Guid tenantId, CancellationToken cancellationToken);
    Task<Result<AutomationResult>> RetryAsync(Guid executionId, AutomationCommand command, CancellationToken cancellationToken);
}
