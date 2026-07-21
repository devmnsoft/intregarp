namespace IntegraRP.Application.Auth;

public interface IAuthenticationService
{
    Task<AuthResult<AuthResponse>> LoginAsync(LoginRequest request, AuthHttpContext context, CancellationToken ct);
    Task<AuthResult<AuthResponse>> RefreshAsync(RefreshRequest request, AuthHttpContext context, CancellationToken ct);
}
