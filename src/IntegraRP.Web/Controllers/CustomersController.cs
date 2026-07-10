using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class CustomersController : Controller { [Route("customers")] public IActionResult Index() => View(); }
