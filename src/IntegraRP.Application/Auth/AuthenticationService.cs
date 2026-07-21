using IntegraRP.Contracts.Auth;
namespace IntegraRP.Application.Auth;

public sealed class AuthenticationService(LoginUseCase login, RefreshTokenUseCase refresh) : IAuthenticationService
{
    public Task<AuthResult<AuthResponse>> LoginAsync(LoginRequest request, AuthHttpContext context, CancellationToken ct) => login.ExecuteAsync(request, context, ct);
    public Task<AuthResult<AuthResponse>> RefreshAsync(RefreshRequest request, AuthHttpContext context, CancellationToken ct) => refresh.ExecuteAsync(request, context, ct);
}
