using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class OrdersController : Controller
{
    [Route("orders")]
    public IActionResult Index() => View();

    [Route("orders/{id:guid}/billing")]
    public IActionResult Billing(Guid id) => View(id);
}
