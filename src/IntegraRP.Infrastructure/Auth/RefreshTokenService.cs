using System.Security.Cryptography;
using System.Text;
using IntegraRP.Application.Auth;
using Microsoft.Extensions.Configuration;

namespace IntegraRP.Infrastructure.Auth;
public sealed class RefreshTokenService(IConfiguration configuration) : IRefreshTokenService
{
    public string CreateToken() => Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
    public string HashToken(string token) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(token))).ToLowerInvariant();
    public DateTimeOffset GetRefreshTokenExpiresAt() => DateTimeOffset.UtcNow.AddDays(configuration.GetValue("Auth:RefreshTokenDays", 30));
}
