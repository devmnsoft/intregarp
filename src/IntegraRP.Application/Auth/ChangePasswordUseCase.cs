using IntegraRP.Contracts.Auth;
namespace IntegraRP.Application.Auth;

public sealed class ChangePasswordUseCase(IAuthenticationRepository repository, IPasswordService passwords)
{
    public async Task<AuthResult<object>> ExecuteAsync(ChangePasswordRequest request, CancellationToken ct)
    {
        if (!passwords.IsValidNewPassword(request.NewPassword, request.ConfirmPassword, out var error))
        {
            return AuthResult<object>.Fail(422, "invalid_password_policy", error);
        }

        var user = await repository.FindUserByIdAsync(request.TenantId, request.UserId, ct);
        if (user is null || user.UserStatus != "ativo" || user.TenantStatus != "ativo")
        {
            return AuthResult<object>.Fail(404, "user_not_found", "Usuário não encontrado para o tenant informado.");
        }

        var currentHash = await repository.GetCredentialAsync(request.TenantId, request.UserId, ct);
        if (!passwords.Verify(user.UserId, user.Email, currentHash, request.CurrentPassword))
        {
            return AuthResult<object>.Fail(403, "invalid_current_password", "Senha atual inválida.");
        }

        if (passwords.Verify(user.UserId, user.Email, currentHash, request.NewPassword))
        {
            return AuthResult<object>.Fail(422, "password_reuse", "A nova senha deve ser diferente da senha atual.");
        }

        var newHash = passwords.Hash(user.UserId, user.Email, request.NewPassword);
        await repository.UpdatePasswordAsync(request.TenantId, request.UserId, newHash, ct);
        await repository.RevokeUserSessionsExceptAsync(request.TenantId, request.UserId, request.SessionId, "password_changed", ct);

        return AuthResult<object>.Ok(new { changed = true });
    }
}
