namespace IntegraRP.Domain.Flow;

public sealed class WorkflowTask
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public WorkflowTaskStatus Status { get; private set; } = WorkflowTaskStatus.Aberta;
    public DateTimeOffset? DueAt { get; init; }
    public void Complete(Guid userId) { if (Status == WorkflowTaskStatus.Concluida) throw new InvalidOperationException("Tarefa concluída não pode ser concluída novamente."); Status = WorkflowTaskStatus.Concluida; }
    public bool IsOverdue(DateTimeOffset now) => (Status == WorkflowTaskStatus.Aberta || Status == WorkflowTaskStatus.Atribuida || Status == WorkflowTaskStatus.EmAndamento) && DueAt < now;
}
