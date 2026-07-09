using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class ActivitiesController : Controller { [Route("activities")] public IActionResult Index() => View(); }
