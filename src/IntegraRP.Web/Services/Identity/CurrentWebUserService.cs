using System.Security.Claims;

namespace IntegraRP.Web.Services.Identity;

public sealed class CurrentWebUserService(IHttpContextAccessor accessor) : ICurrentWebUserService
{
    private ClaimsPrincipal? User => accessor.HttpContext?.User;
    public Guid? UserId => Guid.TryParse(User?.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : null;
    public Guid? TenantId => Guid.TryParse(User?.FindFirstValue("tenant_id"), out var id) ? id : null;
    public Guid? SessionId => Guid.TryParse(User?.FindFirstValue("session_id"), out var id) ? id : null;
    public string? TenantName => User?.FindFirstValue("tenant_name");
    public IReadOnlyList<string> Permissions => User?.FindAll("permissoes").Select(c => c.Value).ToArray() ?? [];
}
