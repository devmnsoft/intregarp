using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class DashboardController : Controller { [Route("dashboard")] public IActionResult Index() => View(); }
