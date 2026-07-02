namespace IntegraRP.Domain.Flow;

public sealed class ProcessTransition
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public Guid ProcessVersionId { get; init; }
    public Guid SourceElementId { get; init; }
    public Guid TargetElementId { get; init; }
    public string Code { get; init; } = string.Empty;
    public TransitionConditionType ConditionType { get; init; } = TransitionConditionType.Always;
    public string ConditionJson { get; init; } = "{}";
}
