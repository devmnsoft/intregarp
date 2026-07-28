using IntegraRP.Web.Services.Onboarding;
using IntegraRP.Web.ViewModels.Onboarding;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class OnboardingController(IOnboardingApiClient api) : Controller
{
    [HttpGet("onboarding")]
    public async Task<IActionResult> Index(CancellationToken ct)
    {
        try { return View(OnboardingPageViewModel.From(await api.ReconcileAsync(ct))); }
        catch (OnboardingApiException ex) when (ex.StatusCode == System.Net.HttpStatusCode.Unauthorized) { return RedirectToAction("SessionExpired", "Account"); }
        catch (OnboardingApiException ex) { ViewData["CorrelationId"] = ex.CorrelationId; ViewData["LoadError"] = ex.Message; return View(); }
    }
    [HttpPost("onboarding/dismiss")]
    public async Task<IActionResult> Dismiss(long rowVersion, CancellationToken ct) { await api.DismissAsync(rowVersion, ct); return RedirectToAction(nameof(Index)); }
    [HttpPost("onboarding/reopen")]
    public async Task<IActionResult> Reopen(long rowVersion, CancellationToken ct) { await api.ReopenAsync(rowVersion, ct); return RedirectToAction(nameof(Index)); }
    [HttpGet("onboarding/company")] public IActionResult Company() => Step("Confirmar dados da empresa", "Revise razão social, documento e contatos.");
    [HttpGet("onboarding/sectors")] public IActionResult Sectors() => Step("Revisar setores", "Confirme ao menos um setor ativo.");
    [HttpGet("onboarding/first-customer")] public IActionResult FirstCustomer() => RedirectToAction("Index", "Customers");
    [HttpGet("onboarding/first-category")] public IActionResult FirstCategory() => RedirectToAction("Categories", "Products");
    [HttpGet("onboarding/first-product")] public IActionResult FirstProduct() => RedirectToAction("Index", "Products");
    [HttpGet("onboarding/first-inventory")] public IActionResult FirstInventory() => RedirectToAction("Index", "Inventory");
    [HttpGet("onboarding/first-order")] public IActionResult FirstOrder() => RedirectToAction("Index", "Orders");
    [HttpGet("onboarding/first-task")] public IActionResult FirstTask() => RedirectToAction("My", "Tasks");
    private IActionResult Step(string title, string description) { ViewData["StepTitle"] = title; ViewData["StepDescription"] = description; return View("Step"); }
}
