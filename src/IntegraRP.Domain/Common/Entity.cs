namespace IntegraRP.Domain.Common;

public abstract class Entity
{
    public Guid Id { get; protected set; } = Guid.NewGuid();
    public DateTimeOffset CriadoEm { get; protected set; } = DateTimeOffset.UtcNow;
}
