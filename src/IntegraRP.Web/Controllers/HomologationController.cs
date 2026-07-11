using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class HomologationController : Controller
{
    [HttpGet("homologation")]
    public IActionResult Index() => View();
}
