using IntegraRP.Application.Auth;
using Microsoft.AspNetCore.Identity;

namespace IntegraRP.Infrastructure.Auth;
public sealed class AspNetPasswordService : IPasswordService
{
    private readonly PasswordHasher<AuthPasswordUser> _hasher = new();
    public bool Verify(Guid userId, string email, string? hash, string password) => !string.IsNullOrWhiteSpace(hash) && _hasher.VerifyHashedPassword(new(userId, email), hash, password) != PasswordVerificationResult.Failed;
    public string Hash(Guid userId, string email, string password) => _hasher.HashPassword(new(userId, email), password);
    public bool IsValidNewPassword(string password, string confirmation, out string error) { if (password != confirmation) { error = "Confirmação de senha não confere."; return false; } if (password.Length < 10 || !password.Any(char.IsDigit) || !password.Any(char.IsUpper) || !password.Any(char.IsLower)) { error = "A senha deve ter ao menos 10 caracteres, letras maiúsculas, minúsculas e números."; return false; } error = string.Empty; return true; }
    private sealed record AuthPasswordUser(Guid Id, string Email);
}
