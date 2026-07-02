using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class BiController : Controller
{
    [Route("bi")][Route("bi/executive")] public IActionResult Executive() => View("Executive");
    [Route("bi/flow")] public IActionResult Flow() => View("Module", "flow");
    [Route("bi/commercial")] public IActionResult Commercial() => View("Module", "commercial");
    [Route("bi/inventory")] public IActionResult Inventory() => View("Module", "inventory");
    [Route("bi/billing")] public IActionResult Billing() => View("Module", "billing");
    [Route("bi/connect")] public IActionResult Connect() => View("Module", "connect");
    [Route("bi/kpis")] public IActionResult Kpis() => View();
    [Route("bi/score")] public IActionResult Score() => View();
    [Route("bi/alerts")] public IActionResult Alerts() => View();
}
