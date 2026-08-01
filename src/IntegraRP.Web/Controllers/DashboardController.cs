using IntegraRP.Web.ViewModels.Dashboard;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class DashboardController : Controller
{
    [Route("dashboard")]
    public IActionResult Index()
    {
        var model = new DashboardViewModel
        {
            Kpis = new[]
            {
                new KpiCardViewModel("Pedidos em andamento", "Indisponível", "API operacional não respondeu", "neutral", "orders", "/orders"),
                new KpiCardViewModel("Tarefas vencidas", "Indisponível", "API operacional não respondeu", "warning", "tasks", "/tasks/my"),
                new KpiCardViewModel("SLA no prazo", "Indisponível", "Indicadores não consolidados", "neutral", "dashboard", "/bi/kpis"),
                new KpiCardViewModel("Estoque crítico", "Indisponível", "Consulta de saldo não respondeu", "warning", "inventory", "/inventory"),
                new KpiCardViewModel("Títulos vencidos", "Indisponível", "Carteira financeira não respondeu", "neutral", "billing", "/billing/titles"),
                new KpiCardViewModel("Score operacional", "Indisponível", "Indicadores não consolidados", "neutral", "timeline", "/bi")
            }
        };
        return View(model);
    }
}
