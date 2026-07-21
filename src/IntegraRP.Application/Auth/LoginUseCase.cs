using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.Auth;

public sealed class LoginUseCase(IAuthenticationRepository repository, IPasswordService passwords, IRefreshTokenService refreshTokens, ITokenService tokens, ILogger<LoginUseCase> logger)
{
    public async Task<AuthResult<AuthResponse>> ExecuteAsync(LoginRequest request, AuthHttpContext context, CancellationToken ct)
    {
        var email = request.Email?.Trim().ToLowerInvariant();
        var tenantSlug = request.TenantSlug?.Trim().ToLowerInvariant();
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(tenantSlug) || string.IsNullOrWhiteSpace(request.Password)) return AuthResult<AuthResponse>.Fail(400, "invalid_request", "Tenant, e-mail e senha são obrigatórios.");
        var user = await repository.FindUserAsync(tenantSlug, email, ct);
        if (user is null || user.UserStatus != "ativo" || user.TenantStatus != "ativo" || user.LockedUntil > DateTimeOffset.UtcNow || !passwords.Verify(user.UserId, user.Email, user.PasswordHash, request.Password))
        {
            await repository.RegisterLoginAttemptAsync(user?.TenantId, user?.UserId, email, false, "invalid_credentials", context.Ip, context.CorrelationId, ct);
            logger.LogWarning("Falha de login sem dados sensíveis. correlation_id={CorrelationId}", context.CorrelationId);
            return AuthResult<AuthResponse>.Fail(401, "invalid_credentials", "Credenciais inválidas ou sessão expirada.");
        }
        var refresh = refreshTokens.CreateToken();
        var session = await repository.CreateSessionAsync(user, request.DeviceId, request.DeviceName, refreshTokens.HashToken(refresh), Guid.NewGuid(), refreshTokens.GetRefreshTokenExpiresAt(), context, ct);
        var roles = await repository.GetRolesAsync(user.TenantId, user.UserId, ct);
        var permissions = await repository.GetPermissionsAsync(user.TenantId, user.UserId, ct);
        var expiresAt = tokens.GetAccessTokenExpiresAt();
        await repository.RegisterLoginAttemptAsync(user.TenantId, user.UserId, email, true, "success", context.Ip, context.CorrelationId, ct);
        return AuthResult<AuthResponse>.Ok(new AuthResponse(tokens.CreateAccessToken(user, roles, permissions, session.SessionId, expiresAt), refresh, expiresAt, new(user.UserId, user.Name, user.Email), new(user.TenantId, user.TenantSlug, user.TenantName), roles, permissions));
    }
}
