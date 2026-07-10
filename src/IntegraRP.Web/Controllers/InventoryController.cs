using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class InventoryController : Controller { [Route("inventory")] public IActionResult Index() => View(); }
