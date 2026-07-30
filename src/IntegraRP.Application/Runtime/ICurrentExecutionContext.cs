namespace IntegraRP.Application.Runtime;

public interface ICurrentExecutionContext
{
    Guid UserId { get; }
    Guid TenantId { get; }
    string? Email { get; }
    IReadOnlySet<string> Roles { get; }
    IReadOnlySet<string> Permissions { get; }
    Guid? SectorId { get; }
    Guid? SessionId { get; }
    bool IsSuperAdmin { get; }
    string CorrelationId { get; }
    string? IpAddress { get; }
    string? UserAgent { get; }
}
