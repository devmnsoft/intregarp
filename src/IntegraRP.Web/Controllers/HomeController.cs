using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class HomeController(ILogger<HomeController> logger) : Controller
{
    public IActionResult Login() => View();

    public IActionResult Page(string? id)
    {
        ViewData["Page"] = string.IsNullOrWhiteSpace(id) ? "Dashboard" : id;
        logger.LogInformation("Abrindo tela Web {Page}", ViewData["Page"]);
        return View();
    }

    public IActionResult Dashboard() => NamedPage("Dashboard");
    public IActionResult Tarefas() => NamedPage("Tarefas");
    public IActionResult Project() => NamedPage("Project Central");
    public IActionResult Processos() => NamedPage("Flow / BPMN");
    public IActionResult Studio() => NamedPage("Studio");
    public IActionResult Setores() => NamedPage("Setores e Organograma");
    public IActionResult Usuarios() => NamedPage("Usuários");
    public IActionResult Clientes() => NamedPage("Clientes");
    public IActionResult Produtos() => NamedPage("Produtos e Estoque");
    public IActionResult Pedidos() => NamedPage("Pedidos");
    public IActionResult Financeiro() => NamedPage("Financeiro");
    public IActionResult Marketing() => NamedPage("Marketing");
    public IActionResult Vendas() => NamedPage("Vendas");
    public IActionResult TradeMarketing() => NamedPage("Trade Marketing");
    public IActionResult Logistica() => NamedPage("Logística");
    public IActionResult Entregas() => NamedPage("Entregas/Romaneio");
    public IActionResult Kpis() => NamedPage("KPIs e Relatórios");
    public IActionResult Configuracoes() => NamedPage("Configurações");

    private IActionResult NamedPage(string page)
    {
        ViewData["Page"] = page;
        return View("Page");
    }
}
