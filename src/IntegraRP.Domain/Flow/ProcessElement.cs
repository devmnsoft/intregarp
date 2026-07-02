namespace IntegraRP.Domain.Flow;

public sealed class ProcessElement
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public Guid ProcessVersionId { get; init; }
    public string Code { get; init; } = string.Empty;
    public string Name { get; init; } = string.Empty;
    public ProcessElementType Type { get; init; }
    public Guid? DepartmentId { get; init; }
    public Guid? UserId { get; init; }
    public Guid? RoleId { get; init; }
    public int? SlaMinutes { get; init; }
    public void Validate() { if (Type == ProcessElementType.HumanTask && DepartmentId is null && UserId is null && RoleId is null) throw new InvalidOperationException("HumanTask precisa ter usuário, setor ou perfil responsável."); }
}
