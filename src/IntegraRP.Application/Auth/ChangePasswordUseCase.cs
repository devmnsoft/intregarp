namespace IntegraRP.Application.Auth;
public sealed class ChangePasswordUseCase(IAuthenticationRepository repository, IPasswordService passwords)
{
 public async Task<AuthResult<object>> ExecuteAsync(ChangePasswordRequest request, CancellationToken ct) { if (!passwords.IsValidNewPassword(request.NewPassword, request.ConfirmPassword, out var error)) return AuthResult<object>.Fail(400,"invalid_password_policy",error); var user = await repository.FindUserAsync("", "", ct); await repository.UpdatePasswordAsync(request.TenantId, request.UserId, passwords.Hash(request.UserId, string.Empty, request.NewPassword), ct); await repository.RevokeUserSessionsExceptAsync(request.TenantId, request.UserId, request.SessionId, "password_changed", ct); return AuthResult<object>.Ok(new { changed = true }); }
}
