namespace IntegraRP.Domain.Studio;

public sealed class DynamicEntity
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public string Name { get; private set; }
    public string Code { get; private set; }
    public bool IsMain { get; private set; }
    public DateTimeOffset CreatedAt { get; init; } = DateTimeOffset.UtcNow;

    public DynamicEntity(Guid tenantId, string name, string code, bool isMain = true)
    {
        if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException("Nome da entidade é obrigatório.", nameof(name));
        if (string.IsNullOrWhiteSpace(code)) throw new ArgumentException("Código da entidade é obrigatório.", nameof(code));
        TenantId = tenantId;
        Name = name;
        Code = code;
        IsMain = isMain;
    }
}
