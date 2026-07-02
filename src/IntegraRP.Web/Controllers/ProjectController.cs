using Microsoft.AspNetCore.Mvc;
namespace IntegraRP.Web.Controllers;
public sealed class ProjectController : Controller
{
    [Route("project")][Route("project/boards")] public IActionResult Boards() => View();
    [Route("project/boards/create")] public IActionResult Create() => View();
    [Route("project/boards/{id:guid}")][Route("project/boards/{id:guid}/kanban")] public IActionResult Kanban(Guid id) { ViewBag.BoardId = id; return View(); }
    [Route("project/boards/{id:guid}/metrics")] public IActionResult Metrics(Guid id) { ViewBag.BoardId = id; return View(); }
    [Route("project/boards/{id:guid}/feed")] public IActionResult Feed(Guid id) { ViewBag.BoardId = id; return View(); }
    [Route("project/boards/{id:guid}/sprints")] public IActionResult Sprints(Guid id) { ViewBag.BoardId = id; return View(); }
    [Route("project/boards/{id:guid}/import-export")] public IActionResult ImportExport(Guid id) { ViewBag.BoardId = id; return View(); }
}
