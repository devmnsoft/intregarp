using IntegraRP.Application.Auth;
using IntegraRP.Web.Services.Identity;
using IntegraRP.Web.ViewModels.Account;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class AccountController(IIdentityApiClient identityApiClient, IIdentitySessionStore sessionStore, IdentityClaimsFactory claimsFactory) : Controller
{
    [AllowAnonymous]
    [HttpGet]
    public IActionResult Login(string? returnUrl = null)
    {
        ViewData["HidePageHeader"] = true;
        return View(new LoginViewModel { ReturnUrl = returnUrl });
    }

    [AllowAnonymous]
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginViewModel model, CancellationToken cancellationToken)
    {
        ViewData["HidePageHeader"] = true;
        if (!ModelState.IsValid) return View(model);
        try
        {
            var deviceId = Request.Cookies["IntegraRP.DeviceId"];
            if (string.IsNullOrWhiteSpace(deviceId))
            {
                deviceId = Guid.NewGuid().ToString("N");
                Response.Cookies.Append("IntegraRP.DeviceId", deviceId, new CookieOptions { HttpOnly = true, SameSite = SameSiteMode.Lax, Secure = Request.IsHttps, MaxAge = TimeSpan.FromDays(365) });
            }

            var response = await identityApiClient.LoginAsync(new LoginRequest(model.Tenant, model.Email, model.Password, deviceId, "Web"), cancellationToken);
            var sessionId = Guid.NewGuid();
            await sessionStore.StoreAsync(sessionId.ToString(), new IdentitySessionTokens(response.AccessToken, response.RefreshToken, response.ExpiresAt, response.Usuario.Id, response.Tenant.Id, sessionId), cancellationToken);
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, claimsFactory.Create(response, sessionId));
            if (model.RememberTenant) Response.Cookies.Append("IntegraRP.Tenant", model.Tenant, new CookieOptions { HttpOnly = true, SameSite = SameSiteMode.Lax, Secure = Request.IsHttps, MaxAge = TimeSpan.FromDays(30) });
            return LocalRedirect(string.IsNullOrWhiteSpace(model.ReturnUrl) ? "/dashboard" : model.ReturnUrl);
        }
        catch (IdentityApiException ex)
        {
            ModelState.AddModelError(string.Empty, ex.StatusCode switch { System.Net.HttpStatusCode.Unauthorized => "Credenciais inválidas.", System.Net.HttpStatusCode.Forbidden => "Acesso negado para esta organização.", (System.Net.HttpStatusCode)429 => "Muitas tentativas. Aguarde alguns minutos.", _ => $"Não foi possível autenticar com segurança agora. CorrelationId: {ex.CorrelationId ?? HttpContext.TraceIdentifier}" });
            return View(model);
        }
    }

    [Authorize]
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Logout(CancellationToken cancellationToken)
    {
        var sessionIdText = User.FindFirst("session_id")?.Value;
        if (Guid.TryParse(sessionIdText, out var sessionId))
        {
            try { await identityApiClient.LogoutAsync(sessionId, false, cancellationToken); } catch (IdentityApiException) { }
            await sessionStore.RemoveAsync(sessionIdText!, cancellationToken);
        }
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        return RedirectToAction(nameof(Login));
    }

    [AllowAnonymous]
    public IActionResult ForgotPassword() { ViewData["HidePageHeader"] = true; return View(); }
    [AllowAnonymous]
    public IActionResult ResetPassword() { ViewData["HidePageHeader"] = true; return View(); }
    [AllowAnonymous]
    public IActionResult AccessDenied() { ViewData["HidePageHeader"] = true; return View(); }
    [AllowAnonymous]
    public IActionResult SessionExpired() { ViewData["HidePageHeader"] = true; return View(); }
}
