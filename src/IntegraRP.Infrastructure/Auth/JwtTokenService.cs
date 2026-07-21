using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using IntegraRP.Application.Auth;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace IntegraRP.Infrastructure.Auth;
public sealed class JwtTokenService(IConfiguration configuration) : ITokenService
{
    public DateTimeOffset GetAccessTokenExpiresAt() => DateTimeOffset.UtcNow.AddMinutes(configuration.GetValue("Jwt:AccessTokenMinutes", 15));
    public string CreateAccessToken(AuthUserRecord user, IReadOnlyList<string> roles, IReadOnlyList<string> permissions, Guid sessionId, DateTimeOffset expiresAt)
    {
        var secret = configuration["Jwt:Secret"] ?? Environment.GetEnvironmentVariable("INTEGRARP_JWT_SECRET") ?? throw new InvalidOperationException("Jwt secret ausente.");
        var claims = new List<Claim> { new(JwtRegisteredClaimNames.Sub, user.UserId.ToString()), new(ClaimTypes.NameIdentifier, user.UserId.ToString()), new("tenant_id", user.TenantId.ToString()), new(ClaimTypes.Email, user.Email), new("session_id", sessionId.ToString()), new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString("N")) };
        claims.AddRange(roles.Select(x => new Claim(ClaimTypes.Role, x))); claims.AddRange(permissions.Select(x => new Claim("permission", x)));
        var jwt = new JwtSecurityToken(configuration["Jwt:Issuer"] ?? "IntegraRP", configuration["Jwt:Audience"] ?? "IntegraRP.Api", claims, expires: expiresAt.UtcDateTime, signingCredentials: new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret)), SecurityAlgorithms.HmacSha256));
        return new JwtSecurityTokenHandler().WriteToken(jwt);
    }
}
