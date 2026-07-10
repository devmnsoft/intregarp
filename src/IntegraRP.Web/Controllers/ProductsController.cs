using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class ProductsController : Controller { [Route("products")] public IActionResult Index() => View(); }
