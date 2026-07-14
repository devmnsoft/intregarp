using System.Security.Claims;

using IntegraRP.Application.Runtime;

namespace IntegraRP.Api.Security;

public interface ICurrentUserContext : ICurrentExecutionContext
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

public sealed class CurrentUserContext(IHttpContextAccessor accessor) : ICurrentUserContext
{
    private ClaimsPrincipal User => accessor.HttpContext?.User ?? new ClaimsPrincipal(new ClaimsIdentity());
    public Guid UserId => ReadGuid(ClaimTypes.NameIdentifier, "sub", "user_id") ?? Guid.Empty;
    public Guid TenantId => ReadGuid("tenant_id", "tenantId") ?? Guid.Empty;
    public string? Email => User.FindFirstValue(ClaimTypes.Email) ?? User.FindFirstValue("email");
    public IReadOnlySet<string> Roles => User.FindAll(ClaimTypes.Role).Select(x => x.Value).Concat(User.FindAll("role").Select(x => x.Value)).ToHashSet(StringComparer.OrdinalIgnoreCase);
    public IReadOnlySet<string> Permissions => User.FindAll(ApiPermissions.ClaimType).Select(x => x.Value).Concat(User.FindAll("permissions").SelectMany(x => x.Value.Split(' ', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))).ToHashSet(StringComparer.OrdinalIgnoreCase);
    public Guid? SectorId => ReadGuid("sector_id", "sectorId");
    public bool IsSuperAdmin => Roles.Contains("SuperAdmin") || User.HasClaim("super_admin", "true");
    public string? CorrelationId => accessor.HttpContext?.TraceIdentifier;

    private Guid? ReadGuid(params string[] claimTypes)
    {
        foreach (var claimType in claimTypes)
        {
            var value = User.FindFirstValue(claimType);
            if (Guid.TryParse(value, out var guid)) return guid;
        }
        return null;
    }
}
