using IntegraRP.Contracts.Auth;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace IntegraRP.Web.Services.Identity;

public sealed class IdentityClaimsFactory
{
    public ClaimsPrincipal Create(AuthResponse response, Guid sessionId)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, response.Usuario.Id.ToString()),
            new(ClaimTypes.Name, response.Usuario.Nome),
            new(ClaimTypes.Email, response.Usuario.Email),
            new("tenant_id", response.Tenant.Id.ToString()),
            new("tenant_slug", response.Tenant.Slug),
            new("tenant_name", response.Tenant.Nome),
            new("session_id", response.SessionId.ToString())
        };
        claims.AddRange(response.Perfis.Select(perfil => new Claim(ClaimTypes.Role, perfil)));
        claims.AddRange(response.Permissoes.Select(permissao => new Claim("permission", permissao)));
        return new ClaimsPrincipal(new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme));
    }
}
