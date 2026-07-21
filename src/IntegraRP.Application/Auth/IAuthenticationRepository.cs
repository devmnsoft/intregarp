using IntegraRP.Contracts.Auth;
namespace IntegraRP.Application.Auth;

public interface IAuthenticationRepository
{
    Task<AuthUserRecord?> FindUserAsync(string tenantSlug, string normalizedEmail, CancellationToken ct);
    Task<AuthUserRecord?> FindUserByTenantSlugAndEmailAsync(string tenantSlug, string normalizedEmail, CancellationToken ct);
    Task<AuthUserRecord?> FindUserByIdAsync(Guid tenantId, Guid userId, CancellationToken ct);
    Task<string?> GetCredentialAsync(Guid tenantId, Guid userId, CancellationToken ct);
    Task IncrementInvalidLoginAsync(Guid? tenantId, Guid? userId, string normalizedEmail, CancellationToken ct);
    Task ResetInvalidLoginAsync(Guid tenantId, Guid userId, CancellationToken ct);
    Task ApplyLockoutAsync(Guid tenantId, Guid userId, DateTimeOffset lockedUntil, CancellationToken ct);
    Task<IReadOnlyList<string>> GetRolesAsync(Guid tenantId, Guid userId, CancellationToken ct);
    Task<IReadOnlyList<string>> GetPermissionsAsync(Guid tenantId, Guid userId, CancellationToken ct);
    Task RegisterLoginAttemptAsync(Guid? tenantId, Guid? userId, string email, bool success, string reason, string? ip, string correlationId, CancellationToken ct);
    Task<AuthSessionRecord> CreateSessionAsync(AuthUserRecord user, string? deviceId, string? deviceName, string refreshHash, Guid familyId, DateTimeOffset refreshExpiresAt, AuthHttpContext context, CancellationToken ct);
    Task<RefreshTokenRotationRecord?> RotateRefreshTokenAsync(string tokenHash, string newTokenHash, DateTimeOffset refreshExpiresAt, AuthHttpContext context, CancellationToken ct);
    Task RevokeSessionAsync(Guid tenantId, Guid userId, Guid sessionId, string reason, CancellationToken ct);
    Task RevokeUserSessionsExceptAsync(Guid tenantId, Guid userId, Guid? keepSessionId, string reason, CancellationToken ct);
    Task<bool> IsSessionActiveAsync(Guid tenantId, Guid userId, Guid sessionId, CancellationToken ct);
    Task UpdatePasswordAsync(Guid tenantId, Guid userId, string passwordHash, CancellationToken ct);
    Task<PasswordResetIssueResult?> CreatePasswordResetAsync(string tenantSlug, string normalizedEmail, string tokenHash, DateTimeOffset expiresAt, CancellationToken ct);
    Task<bool> ConsumePasswordResetAsync(string tenantSlug, string normalizedEmail, string tokenHash, string newPasswordHash, CancellationToken ct);
    Task<IReadOnlyList<AuthSessionDto>> ListSessionsAsync(Guid tenantId, Guid userId, CancellationToken ct);
}

public sealed record AuthUserRecord(Guid UserId, Guid TenantId, string Email, string Name, string TenantSlug, string TenantName, string? PasswordHash, string UserStatus, string TenantStatus, DateTimeOffset? LockedUntil);
public sealed record AuthSessionRecord(Guid SessionId);
public sealed record RefreshTokenRotationRecord(AuthUserRecord User, Guid SessionId, Guid FamilyId);
public sealed record PasswordResetIssueResult(Guid TenantId, Guid UserId, string Email, string TokenHash);
