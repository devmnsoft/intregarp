using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class TasksController : Controller { [Route("tasks/my")] public IActionResult My() => View(); }
