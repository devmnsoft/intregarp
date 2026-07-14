namespace IntegraRP.Application.Runtime;

public interface ICurrentExecutionContext
{
    Guid UserId { get; }
    Guid TenantId { get; }
    string? Email { get; }
    IReadOnlySet<string> Roles { get; }
    IReadOnlySet<string> Permissions { get; }
    Guid? SectorId { get; }
    bool IsSuperAdmin { get; }
    string? CorrelationId { get; }
}
