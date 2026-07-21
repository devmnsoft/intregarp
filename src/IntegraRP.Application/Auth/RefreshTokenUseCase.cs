using IntegraRP.Contracts.Auth;
namespace IntegraRP.Application.Auth;
public sealed class RefreshTokenUseCase(IAuthenticationRepository repository, IRefreshTokenService refreshTokens, ITokenService tokens)
{
    public async Task<AuthResult<AuthResponse>> ExecuteAsync(RefreshRequest request, AuthHttpContext context, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(request.RefreshToken)) return AuthResult<AuthResponse>.Fail(401, "invalid_refresh", "Credenciais inválidas ou sessão expirada.");
        var refresh = refreshTokens.CreateToken();
        var rotation = await repository.RotateRefreshTokenAsync(refreshTokens.HashToken(request.RefreshToken), refreshTokens.HashToken(refresh), refreshTokens.GetRefreshTokenExpiresAt(), context, ct);
        if (rotation is null) return AuthResult<AuthResponse>.Fail(401, "invalid_refresh", "Credenciais inválidas ou sessão expirada.");
        var roles = await repository.GetRolesAsync(rotation.User.TenantId, rotation.User.UserId, ct);
        var permissions = await repository.GetPermissionsAsync(rotation.User.TenantId, rotation.User.UserId, ct);
        var expiresAt = tokens.GetAccessTokenExpiresAt();
        return AuthResult<AuthResponse>.Ok(new AuthResponse(tokens.CreateAccessToken(rotation.User, roles, permissions, rotation.SessionId, expiresAt), refresh, expiresAt, rotation.SessionId, new(rotation.User.UserId, rotation.User.Name, rotation.User.Email), new(rotation.User.TenantId, rotation.User.TenantSlug, rotation.User.TenantName), roles, permissions));
    }
}
