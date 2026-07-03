namespace IntegraRP.Domain.Studio;

public sealed class DynamicAction
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public string Name { get; private set; }
    public string Code { get; private set; }
    public DynamicActionType Type { get; private set; }
    public DateTimeOffset CreatedAt { get; init; } = DateTimeOffset.UtcNow;

    public DynamicAction(Guid tenantId, string name, string code, DynamicActionType type, bool hasBpmnBinding = false)
    {
        if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException("Nome da ação é obrigatório.", nameof(name));
        if (string.IsNullOrWhiteSpace(code)) throw new ArgumentException("Código da ação é obrigatório.", nameof(code));
        if (type == DynamicActionType.StartWorkflow && !hasBpmnBinding) throw new InvalidOperationException("Ação start_workflow precisa de vínculo BPMN.");
        TenantId = tenantId;
        Name = name;
        Code = code;
        Type = type;
    }
}
