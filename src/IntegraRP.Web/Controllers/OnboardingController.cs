using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class OnboardingController : Controller
{
    [HttpGet("onboarding")] public IActionResult Index() => View();
    [HttpGet("onboarding/company")] public IActionResult Company() => Step("Confirmar dados da empresa", "Revise razão social, documento e contatos.");
    [HttpGet("onboarding/users")] public IActionResult Users() => Step("Criar usuários", "Convide a equipe e defina responsáveis.");
    [HttpGet("onboarding/sectors")] public IActionResult Sectors() => Step("Criar setores", "Organize áreas e SLAs por setor.");
    [HttpGet("onboarding/modules")] public IActionResult Modules() => Step("Escolher módulos", "Ative módulos que fazem sentido para a operação.");
    [HttpGet("onboarding/templates")] public IActionResult Templates() => Step("Instalar templates", "Comece com pacotes operacionais prontos.");
    [HttpGet("onboarding/first-process")] public IActionResult FirstProcess() => Step("Criar primeiro processo", "Modele e publique o fluxo inicial.");
    [HttpGet("onboarding/first-order")] public IActionResult FirstOrder() => Step("Criar primeiro pedido", "Valide cliente, produto, estoque e faturamento.");
    private IActionResult Step(string title, string description) { ViewData["StepTitle"] = title; ViewData["StepDescription"] = description; return View("Step"); }
}
