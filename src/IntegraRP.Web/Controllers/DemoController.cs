using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class DemoController : Controller { [Route("demo")] public IActionResult Index() => View(); }
