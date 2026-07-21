using System.Security.Claims;
using IntegraRP.Application.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/auth")]
public sealed class AuthController(LoginUseCase login, RefreshTokenUseCase refresh, LogoutUseCase logout, GetCurrentUserUseCase me, ChangePasswordUseCase changePassword, ForgotPasswordUseCase forgotPassword, ResetPasswordUseCase resetPassword, IAuthenticationRepository repository) : ControllerBase
{
    [AllowAnonymous]
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken ct) => ToActionResult(await login.ExecuteAsync(request, GetAuthContext(), ct));

    [AllowAnonymous]
    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh([FromBody] RefreshRequest request, CancellationToken ct) => ToActionResult(await refresh.ExecuteAsync(request, GetAuthContext(), ct));

    [Authorize]
    [HttpPost("logout")]
    public async Task<IActionResult> Logout([FromBody] LogoutRequest? request, CancellationToken ct)
    {
        var ids = GetRequiredIds();
        var result = await logout.ExecuteAsync(ids.TenantId, ids.UserId, request?.SessionId ?? ids.SessionId, request?.AllSessions ?? false, ct);
        return result.Success ? NoContent() : ToActionResult(result);
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> Me(CancellationToken ct)
    {
        var ids = GetRequiredIds();
        return ToActionResult(await me.ExecuteAsync(ids.TenantId, ids.UserId, ids.SessionId, User.FindFirstValue(ClaimTypes.Email), ct));
    }

    [Authorize]
    [HttpPost("change-password")]
    public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordHttpRequest request, CancellationToken ct)
    {
        var ids = GetRequiredIds();
        return ToActionResult(await changePassword.ExecuteAsync(new ChangePasswordRequest(ids.UserId, ids.TenantId, ids.SessionId, request.CurrentPassword, request.NewPassword, request.ConfirmPassword), ct));
    }

    [AllowAnonymous]
    [HttpPost("forgot-password")]
    public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request, CancellationToken ct) => ToActionResult(await forgotPassword.ExecuteAsync(request, ct));

    [AllowAnonymous]
    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request, CancellationToken ct) => ToActionResult(await resetPassword.ExecuteAsync(request, ct));

    [Authorize]
    [HttpGet("sessions")]
    public async Task<IActionResult> Sessions(CancellationToken ct)
    {
        var ids = GetRequiredIds();
        return Ok(await repository.ListSessionsAsync(ids.TenantId, ids.UserId, ct));
    }

    [Authorize]
    [HttpDelete("sessions/{sessionId:guid}")]
    public async Task<IActionResult> RevokeSession(Guid sessionId, CancellationToken ct)
    {
        var ids = GetRequiredIds();
        await repository.RevokeSessionAsync(ids.TenantId, ids.UserId, sessionId, "user_revoked", ct);
        return NoContent();
    }

    private AuthHttpContext GetAuthContext() => new(HttpContext.Connection.RemoteIpAddress?.ToString(), Request.Headers.UserAgent.ToString(), HttpContext.TraceIdentifier);

    private (Guid TenantId, Guid UserId, Guid SessionId) GetRequiredIds() => (Guid.Parse(User.FindFirstValue("tenant_id")!), Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier) ?? User.FindFirstValue("sub")!), Guid.Parse(User.FindFirstValue("session_id")!));

    private IActionResult ToActionResult<T>(AuthResult<T> result)
    {
        if (result.Success && result.StatusCode == StatusCodes.Status202Accepted) return Accepted(new { status = result.Code, message = result.Message, correlation_id = HttpContext.TraceIdentifier });
        if (result.Success) return Ok(result.Value);
        return StatusCode(result.StatusCode, new ProblemDetails { Title = result.Message, Status = result.StatusCode, Type = $"https://integrarp.local/problems/{result.Code}", Extensions = { ["correlation_id"] = HttpContext.TraceIdentifier } });
    }
}

public sealed record ChangePasswordHttpRequest(string CurrentPassword, string NewPassword, string ConfirmPassword);
