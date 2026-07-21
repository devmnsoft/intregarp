using System.Security.Claims;
using IntegraRP.Application.Auth;
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
            new("session_id", sessionId.ToString())
        };
        claims.AddRange(response.Perfis.Select(perfil => new Claim("perfis", perfil)));
        claims.AddRange(response.Permissoes.Select(permissao => new Claim("permissoes", permissao)));
        return new ClaimsPrincipal(new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme));
    }
}
