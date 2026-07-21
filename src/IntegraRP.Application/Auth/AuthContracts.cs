namespace IntegraRP.Application.Auth;

public sealed record LoginRequest(string TenantSlug, string Email, string Password, string? DeviceId, string? DeviceName);
public sealed record RefreshRequest(string RefreshToken);
public sealed record LogoutRequest(Guid? SessionId, bool AllSessions);
public sealed record ChangePasswordRequest(Guid UserId, Guid TenantId, Guid SessionId, string CurrentPassword, string NewPassword, string ConfirmPassword);
public sealed record ForgotPasswordRequest(string TenantSlug, string Email);
public sealed record ResetPasswordRequest(string TenantSlug, string Email, string Token, string NewPassword, string ConfirmPassword);
public sealed record AuthUserDto(Guid Id, string Nome, string Email);
public sealed record AuthTenantDto(Guid Id, string Slug, string Nome);
public sealed record AuthResponse(string AccessToken, string RefreshToken, DateTimeOffset ExpiresAt, AuthUserDto Usuario, AuthTenantDto Tenant, IReadOnlyList<string> Perfis, IReadOnlyList<string> Permissoes);
public sealed record CurrentUserResponse(Guid UserId, Guid TenantId, string? Email, Guid SessionId, IReadOnlyList<string> Perfis, IReadOnlyList<string> Permissoes);
public sealed record AuthSessionDto(Guid Id, string? DeviceId, string? DeviceName, DateTimeOffset CriadoEm, DateTimeOffset ExpiresAt, DateTimeOffset? RevokedAt);
public sealed record AuthHttpContext(string? Ip, string? UserAgent, string CorrelationId);
