using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class OnboardingController : Controller
{
    [HttpGet("onboarding")] public IActionResult Index() => View();
    [HttpGet("onboarding/company")] public IActionResult Company() => Step("Confirmar dados da empresa", "Revise razão social, documento e contatos.");
    [HttpGet("onboarding/sectors")] public IActionResult Sectors() => Step("Revisar setores", "Confirme ao menos um setor ativo para distribuir responsabilidades.");
    [HttpGet("onboarding/first-customer")] public IActionResult FirstCustomer() => Step("Cadastrar primeiro cliente", "Cadastre o cliente que fará parte do primeiro pedido.");
    [HttpGet("onboarding/first-category")] public IActionResult FirstCategory() => Step("Cadastrar primeira categoria", "Organize o catálogo antes de incluir produtos.");
    [HttpGet("onboarding/first-product")] public IActionResult FirstProduct() => Step("Cadastrar primeiro produto", "Associe um produto ativo à categoria criada.");
    [HttpGet("onboarding/first-inventory")] public IActionResult FirstInventory() => Step("Registrar primeiro estoque", "Registre uma entrada em um local para disponibilizar o produto.");
    [HttpGet("onboarding/first-order")] public IActionResult FirstOrder() => Step("Criar primeiro pedido", "Valide cliente, produto, estoque e faturamento.");
    [HttpGet("onboarding/first-task")] public IActionResult FirstTask() => Step("Concluir primeira tarefa", "Execute a separação com checklist e evidência.");
    private IActionResult Step(string title, string description) { ViewData["StepTitle"] = title; ViewData["StepDescription"] = description; return View("Step"); }
}
