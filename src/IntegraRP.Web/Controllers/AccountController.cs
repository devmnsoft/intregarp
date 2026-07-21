using System.Security.Claims;
using IntegraRP.Web.ViewModels.Account;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class AccountController(IHttpClientFactory httpClientFactory, IWebHostEnvironment environment) : Controller
{
    [HttpGet]
    public IActionResult Login(string? returnUrl = null)
    {
        ViewData["HidePageHeader"] = true;
        return View(new LoginViewModel { ReturnUrl = returnUrl });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginViewModel model, CancellationToken cancellationToken)
    {
        ViewData["HidePageHeader"] = true;
        if (!ModelState.IsValid) return View(model);
        using var request = new HttpRequestMessage(HttpMethod.Post, "/auth/login") { Content = JsonContent.Create(new { tenant = model.Tenant, email = model.Email, password = model.Password }) };
        using var response = await httpClientFactory.CreateClient("IntegraRP.Api").SendAsync(request, cancellationToken);
        if (!response.IsSuccessStatusCode)
        {
            ModelState.AddModelError(string.Empty, response.StatusCode switch { System.Net.HttpStatusCode.Unauthorized => "Credenciais inválidas.", System.Net.HttpStatusCode.Forbidden => "Acesso negado para esta organização.", (System.Net.HttpStatusCode)429 => "Muitas tentativas. Aguarde alguns minutos.", _ => "Não foi possível autenticar com segurança agora." });
            return View(model);
        }
        var claims = new[] { new Claim(ClaimTypes.Name, model.Email), new Claim("tenant", model.Tenant), new Claim(ClaimTypes.Role, "Administrador") };
        await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme)));
        if (model.RememberTenant) Response.Cookies.Append("IntegraRP.Tenant", model.Tenant, new CookieOptions { HttpOnly = true, SameSite = SameSiteMode.Lax, Secure = Request.IsHttps, MaxAge = TimeSpan.FromDays(30) });
        return LocalRedirect(string.IsNullOrWhiteSpace(model.ReturnUrl) ? "/dashboard" : model.ReturnUrl);
    }

    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        return RedirectToAction(nameof(Login));
    }

    public IActionResult ForgotPassword() { ViewData["HidePageHeader"] = true; return View(); }
    public IActionResult ResetPassword() { ViewData["HidePageHeader"] = true; return View(); }
    public IActionResult AccessDenied() { ViewData["HidePageHeader"] = true; return View(); }
    public IActionResult SessionExpired() { ViewData["HidePageHeader"] = true; return View(); }
}
