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
                new KpiCardViewModel("Pedidos em andamento", "—", "Aguardando dados da API", "neutral", "bi-receipt", "/orders"),
                new KpiCardViewModel("Tarefas vencidas", "—", "Conecte a API para calcular atrasos", "warning", "bi-check2-square", "/tasks/my"),
                new KpiCardViewModel("SLA no prazo", "—", "Sem eventos consolidados", "neutral", "bi-speedometer2", "/bi/kpis"),
                new KpiCardViewModel("Estoque crítico", "—", "Sem leitura de saldo disponível", "warning", "bi-boxes", "/inventory"),
                new KpiCardViewModel("Títulos vencidos", "—", "Sem carteira financeira carregada", "neutral", "bi-cash-coin", "/billing/titles"),
                new KpiCardViewModel("Score operacional", "—", "Aguardando indicadores reais", "neutral", "bi-graph-up", "/bi")
            }
        };
        return View(model);
    }
}
