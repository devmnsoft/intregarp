using System.Security.Claims;
using IntegraRP.Application.Auth;

namespace IntegraRP.Web.Services.Identity;

public interface IIdentityApiClient
{
    Task<AuthResponse> LoginAsync(LoginRequest request, CancellationToken cancellationToken);
    Task<AuthResponse> RefreshAsync(string refreshToken, CancellationToken cancellationToken);
    Task LogoutAsync(Guid? sessionId, bool allSessions, CancellationToken cancellationToken);
    Task<IReadOnlyList<AuthSessionDto>> ListSessionsAsync(CancellationToken cancellationToken);
    Task RevokeSessionAsync(Guid sessionId, CancellationToken cancellationToken);
    Task ForgotPasswordAsync(ForgotPasswordRequest request, CancellationToken cancellationToken);
    Task ResetPasswordAsync(ResetPasswordRequest request, CancellationToken cancellationToken);
}

public sealed record IdentitySessionTokens(string AccessToken, string RefreshToken, DateTimeOffset ExpiresAt, Guid UserId, Guid TenantId, Guid SessionId);

public interface IIdentitySessionStore
{
    Task StoreAsync(string sessionId, IdentitySessionTokens tokens, CancellationToken cancellationToken);
    Task<IdentitySessionTokens?> GetAsync(string sessionId, CancellationToken cancellationToken);
    Task RemoveAsync(string sessionId, CancellationToken cancellationToken);
}

public interface ICurrentWebUserService
{
    Guid? UserId { get; }
    Guid? TenantId { get; }
    Guid? SessionId { get; }
    string? TenantName { get; }
    IReadOnlyList<string> Permissions { get; }
}
