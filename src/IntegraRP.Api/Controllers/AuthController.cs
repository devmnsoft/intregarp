using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using IntegraRP.Infrastructure.Repositories.Postgres;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Npgsql;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/auth")]
public sealed class AuthController(PostgresConnectionFactory connectionFactory, IConfiguration configuration, ILogger<AuthController> logger) : ControllerBase
{
    private static readonly PasswordHasher<AuthUser> Hasher = new();

    [AllowAnonymous]
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken ct)
    {
        var email = request.Email?.Trim().ToLowerInvariant();
        var tenantSlug = request.TenantSlug?.Trim().ToLowerInvariant();
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(tenantSlug) || string.IsNullOrWhiteSpace(request.Password)) return ValidationProblem("Tenant, e-mail e senha são obrigatórios.");

        await using var c = (NpgsqlConnection)await connectionFactory.OpenAsync(ct);
        var user = await QueryUserAsync(c, tenantSlug, email, ct);
        if (user is null || user.UserStatus != "ativo" || user.TenantStatus != "ativo" || user.LockedUntil > DateTimeOffset.UtcNow || string.IsNullOrWhiteSpace(user.PasswordHash))
        {
            await RegisterAttemptAsync(c, user?.TenantId, user?.UserId, email, false, "invalid_or_inactive", ct);
            return UnauthorizedProblem();
        }

        var verification = Hasher.VerifyHashedPassword(new AuthUser(user.UserId, user.Email), user.PasswordHash, request.Password);
        if (verification == PasswordVerificationResult.Failed)
        {
            await RegisterAttemptAsync(c, user.TenantId, user.UserId, email, false, "invalid_password", ct);
            return UnauthorizedProblem();
        }

        var permissions = await QueryPermissionsAsync(c, user.TenantId, user.UserId, ct);
        var roles = await QueryRolesAsync(c, user.TenantId, user.UserId, ct);
        var sessionId = Guid.NewGuid();
        var refresh = CreateOpaqueToken();
        var refreshHash = HashSecret(refresh);
        await using var tx = await c.BeginTransactionAsync(ct);
        await ExecAsync(c, tx, "INSERT INTO integrarp.auth_sessao (id,tenant_id,usuario_id,device_id,device_name,criado_em,expires_at) VALUES (@id,@tenant,@user,@device,@deviceName,now(),now()+ interval '30 days');", ct, P("id", sessionId), P("tenant", user.TenantId), P("user", user.UserId), P("device", request.DeviceId), P("deviceName", request.DeviceName));
        await ExecAsync(c, tx, "INSERT INTO integrarp.auth_refresh_token (tenant_id,usuario_id,sessao_id,token_hash,family_id,expires_at,criado_em) VALUES (@tenant,@user,@session,@hash,@family,now()+ interval '30 days',now());", ct, P("tenant", user.TenantId), P("user", user.UserId), P("session", sessionId), P("hash", refreshHash), P("family", sessionId));
        await ExecAsync(c, tx, "UPDATE integrarp.usuario SET ultimo_login_em=now(), tentativas_invalidas=0, atualizado_em=now() WHERE tenant_id=@tenant AND id=@user;", ct, P("tenant", user.TenantId), P("user", user.UserId));
        await tx.CommitAsync(ct);
        await RegisterAttemptAsync(c, user.TenantId, user.UserId, email, true, "success", ct);
        var expiresAt = DateTimeOffset.UtcNow.AddMinutes(configuration.GetValue("Jwt:AccessTokenMinutes", 15));
        var accessToken = CreateJwt(user, roles, permissions, sessionId, expiresAt);
        return Ok(new AuthResponse(accessToken, refresh, expiresAt, new UserDto(user.UserId, user.Name, user.Email), new TenantDto(user.TenantId, user.TenantSlug, user.TenantName), roles, permissions));
    }

    [AllowAnonymous]
    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh([FromBody] RefreshRequest request, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(request.RefreshToken)) return UnauthorizedProblem();
        var hash = HashSecret(request.RefreshToken);
        await using var c = (NpgsqlConnection)await connectionFactory.OpenAsync(ct);
        var token = await FirstAsync(c, "SELECT rt.id,rt.tenant_id,rt.usuario_id,rt.sessao_id,rt.family_id,rt.revoked_at,rt.used_at,rt.expires_at,u.email,u.nome,u.status AS user_status,t.slug,t.nome AS tenant_nome,COALESCE(t.status,'ativo') AS tenant_status FROM integrarp.auth_refresh_token rt JOIN integrarp.usuario u ON u.id=rt.usuario_id AND u.tenant_id=rt.tenant_id JOIN integrarp.tenant t ON t.id=rt.tenant_id WHERE rt.token_hash=@hash;", ct, P("hash", hash));
        if (token is null || token["revoked_at"] is not null || token["used_at"] is not null || (DateTimeOffset)token["expires_at"]! <= DateTimeOffset.UtcNow || (string)token["user_status"]! != "ativo" || (string)token["tenant_status"]! != "ativo") return UnauthorizedProblem();
        var user = new UserRow((Guid)token["usuario_id"]!, (Guid)token["tenant_id"]!, (string)token["email"]!, (string)token["nome"]!, (string)token["slug"]!, (string)token["tenant_nome"]!, "", "ativo", "ativo", null);
        var roles = await QueryRolesAsync(c, user.TenantId, user.UserId, ct); var permissions = await QueryPermissionsAsync(c, user.TenantId, user.UserId, ct);
        var refresh = CreateOpaqueToken(); var newHash = HashSecret(refresh); var expiresAt = DateTimeOffset.UtcNow.AddMinutes(configuration.GetValue("Jwt:AccessTokenMinutes", 15));
        await ExecAsync(c, null, "UPDATE integrarp.auth_refresh_token SET used_at=now(), replaced_by_hash=@new_hash WHERE id=@id; INSERT INTO integrarp.auth_refresh_token (tenant_id,usuario_id,sessao_id,token_hash,family_id,expires_at,criado_em) VALUES (@tenant,@user,@session,@new_hash,@family,now()+ interval '30 days',now());", ct, P("id", (Guid)token["id"]!), P("new_hash", newHash), P("tenant", user.TenantId), P("user", user.UserId), P("session", (Guid)token["sessao_id"]!), P("family", (Guid)token["family_id"]!));
        return Ok(new AuthResponse(CreateJwt(user, roles, permissions, (Guid)token["sessao_id"]!, expiresAt), refresh, expiresAt, new UserDto(user.UserId, user.Name, user.Email), new TenantDto(user.TenantId, user.TenantSlug, user.TenantName), roles, permissions));
    }

    [Authorize]
    [HttpPost("logout")]
    public async Task<IActionResult> Logout(CancellationToken ct)
    { await using var c = (NpgsqlConnection)await connectionFactory.OpenAsync(ct); var sid = User.FindFirstValue("session_id"); if (Guid.TryParse(sid, out var sessionId)) await ExecAsync(c, null, "UPDATE integrarp.auth_sessao SET revoked_at=now() WHERE id=@id; UPDATE integrarp.auth_refresh_token SET revoked_at=now() WHERE sessao_id=@id AND revoked_at IS NULL;", ct, P("id", sessionId)); return NoContent(); }
    [Authorize][HttpGet("me")] public IActionResult Me() => Ok(new { userId = User.FindFirstValue(ClaimTypes.NameIdentifier) ?? User.FindFirstValue("sub"), tenantId = User.FindFirstValue("tenant_id"), email = User.FindFirstValue(ClaimTypes.Email), roles = User.FindAll(ClaimTypes.Role).Select(x => x.Value), permissions = User.FindAll("permission").Select(x => x.Value) });
    [Authorize][HttpPost("change-password")] public IActionResult ChangePassword() => Accepted(new { status = "queued", message = "Troca de senha registrada para implementação operacional assistida." });
    [AllowAnonymous][HttpPost("forgot-password")] public IActionResult ForgotPassword() => Accepted(new { status = "accepted" });
    [AllowAnonymous][HttpPost("reset-password")] public IActionResult ResetPassword() => Accepted(new { status = "accepted" });

    private string CreateJwt(UserRow user, IReadOnlyList<string> roles, IReadOnlyList<string> permissions, Guid sessionId, DateTimeOffset expiresAt)
    { var secret = configuration["Jwt:Secret"] ?? Environment.GetEnvironmentVariable("INTEGRARP_JWT_SECRET")!; var claims = new List<Claim>{new(JwtRegisteredClaimNames.Sub,user.UserId.ToString()),new(ClaimTypes.NameIdentifier,user.UserId.ToString()),new("tenant_id",user.TenantId.ToString()),new(ClaimTypes.Email,user.Email),new(JwtRegisteredClaimNames.Jti,Guid.NewGuid().ToString("N")),new("session_id",sessionId.ToString()),new("issued_at",DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString())}; claims.AddRange(roles.Select(r=>new Claim(ClaimTypes.Role,r))); claims.AddRange(permissions.Select(p=>new Claim("permission",p))); var token = new JwtSecurityToken(configuration["Jwt:Issuer"] ?? "IntegraRP", configuration["Jwt:Audience"] ?? "IntegraRP.Api", claims, expires: expiresAt.UtcDateTime, signingCredentials: new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret)), SecurityAlgorithms.HmacSha256)); return new JwtSecurityTokenHandler().WriteToken(token); }
    private static string CreateOpaqueToken(){ var bytes=RandomNumberGenerator.GetBytes(64); return Convert.ToBase64String(bytes); }
    private static string HashSecret(string value){ var bytes=SHA256.HashData(Encoding.UTF8.GetBytes(value)); return Convert.ToHexString(bytes).ToLowerInvariant(); }
    private async Task<UserRow?> QueryUserAsync(NpgsqlConnection c,string slug,string email,CancellationToken ct){ var row=await FirstAsync(c,"SELECT u.id,u.tenant_id,u.email,u.nome,t.slug,t.nome AS tenant_nome,COALESCE(uc.password_hash,u.senha_hash) AS password_hash,COALESCE(u.status,'ativo') AS user_status,COALESCE(t.status,'ativo') AS tenant_status,u.bloqueado_ate FROM integrarp.usuario u JOIN integrarp.tenant t ON t.id=u.tenant_id LEFT JOIN integrarp.usuario_credencial uc ON uc.usuario_id=u.id AND uc.tenant_id=u.tenant_id WHERE lower(t.slug)=@slug AND lower(u.email)=@email AND u.excluido_em IS NULL AND t.excluido_em IS NULL;",ct,P("slug",slug),P("email",email)); return row is null?null:new((Guid)row["id"]!,(Guid)row["tenant_id"]!,(string)row["email"]!,(string)row["nome"]!,(string)row["slug"]!,(string)row["tenant_nome"]!,row["password_hash"] as string,(string)row["user_status"]!,(string)row["tenant_status"]!,row["bloqueado_ate"] as DateTimeOffset?); }
    private static async Task<IReadOnlyList<string>> QueryPermissionsAsync(NpgsqlConnection c,Guid t,Guid u,CancellationToken ct)=>(await QueryScalarAsync(c,"SELECT DISTINCT p.codigo FROM integrarp.usuario_perfil up JOIN integrarp.perfil_permissao pp ON pp.perfil_id=up.perfil_id AND pp.tenant_id=up.tenant_id JOIN integrarp.permissao p ON p.id=pp.permissao_id AND p.tenant_id=pp.tenant_id WHERE up.tenant_id=@tenant AND up.usuario_id=@user AND up.excluido_em IS NULL AND p.excluido_em IS NULL ORDER BY p.codigo;",ct,P("tenant",t),P("user",u))).ToArray();
    private static async Task<IReadOnlyList<string>> QueryRolesAsync(NpgsqlConnection c,Guid t,Guid u,CancellationToken ct)=>(await QueryScalarAsync(c,"SELECT DISTINCT pf.nome FROM integrarp.usuario_perfil up JOIN integrarp.perfil pf ON pf.id=up.perfil_id AND pf.tenant_id=up.tenant_id WHERE up.tenant_id=@tenant AND up.usuario_id=@user AND up.excluido_em IS NULL AND pf.excluido_em IS NULL ORDER BY pf.nome;",ct,P("tenant",t),P("user",u))).ToArray();
    private async Task RegisterAttemptAsync(NpgsqlConnection c,Guid? t,Guid? u,string? e,bool success,string reason,CancellationToken ct){ try{ await ExecAsync(c,null,"INSERT INTO integrarp.auth_login_tentativa (tenant_id,usuario_id,email_normalizado,sucesso,reason,ip,criado_em) VALUES (@tenant,@user,@email,@success,@reason,@ip,now());",ct,P("tenant",t),P("user",u),P("email",e),P("success",success),P("reason",reason),P("ip",HttpContext.Connection.RemoteIpAddress?.ToString())); } catch(Exception ex){ logger.LogWarning(ex,"Falha ao registrar tentativa de login sem dados sensíveis."); } }
    private static IActionResult UnauthorizedProblem()=>new UnauthorizedObjectResult(new ProblemDetails{Title="Credenciais inválidas ou sessão expirada",Status=StatusCodes.Status401Unauthorized});
    private static async Task<List<string>> QueryScalarAsync(NpgsqlConnection c,string sql,CancellationToken ct,params NpgsqlParameter[] p){ await using var cmd=c.CreateCommand(); cmd.CommandText=sql; foreach(var x in p)cmd.Parameters.Add(x); var list=new List<string>(); await using var r=await cmd.ExecuteReaderAsync(ct); while(await r.ReadAsync(ct)) list.Add(r.GetString(0)); return list; }
    private static async Task<Dictionary<string,object?>?> FirstAsync(NpgsqlConnection c,string sql,CancellationToken ct,params NpgsqlParameter[] p){ await using var cmd=c.CreateCommand(); cmd.CommandText=sql; foreach(var x in p)cmd.Parameters.Add(x); await using var r=await cmd.ExecuteReaderAsync(ct); if(!await r.ReadAsync(ct)) return null; var d=new Dictionary<string,object?>(StringComparer.OrdinalIgnoreCase); for(var i=0;i<r.FieldCount;i++) d[r.GetName(i)]=await r.IsDBNullAsync(i,ct)?null:r.GetValue(i); return d; }
    private static async Task ExecAsync(NpgsqlConnection c,NpgsqlTransaction? tx,string sql,CancellationToken ct,params NpgsqlParameter[] p){ await using var cmd=c.CreateCommand(); cmd.Transaction=tx; cmd.CommandText=sql; foreach(var x in p)cmd.Parameters.Add(x); await cmd.ExecuteNonQueryAsync(ct); }
    private static NpgsqlParameter P(string n,object? v)=>new(n,v??DBNull.Value);
    private sealed record AuthUser(Guid Id,string Email); private sealed record UserRow(Guid UserId,Guid TenantId,string Email,string Name,string TenantSlug,string TenantName,string? PasswordHash,string UserStatus,string TenantStatus,DateTimeOffset? LockedUntil);
    public sealed record LoginRequest(string TenantSlug,string Email,string Password,string? DeviceId,string? DeviceName); public sealed record RefreshRequest(string RefreshToken); public sealed record AuthResponse(string AccessToken,string RefreshToken,DateTimeOffset ExpiresAt,UserDto Usuario,TenantDto Tenant,IReadOnlyList<string> Perfis,IReadOnlyList<string> Permissoes); public sealed record UserDto(Guid Id,string Nome,string Email); public sealed record TenantDto(Guid Id,string Slug,string Nome);
}
