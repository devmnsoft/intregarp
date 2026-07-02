using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

[Route("flow")]
public sealed class FlowController : Controller
{
    [HttpGet("")]
    public IActionResult Dashboard() => View("Dashboard");

    [HttpGet("definitions")]
    public IActionResult Definitions() => View("Definitions");

    [HttpGet("definitions/create")]
    public IActionResult CreateDefinition() => View("CreateDefinition");

    [HttpGet("definitions/{id:guid}")]
    public IActionResult DefinitionDetail(Guid id) { ViewData["DefinitionId"] = id; return View("DefinitionDetail"); }

    [HttpGet("versions/{id:guid}")]
    public IActionResult VersionEditor(Guid id) { ViewData["VersionId"] = id; return View("VersionEditor"); }

    [HttpGet("designer")]
    public IActionResult Designer() => View("~/Views/FlowDesigner/Index.cshtml");

    [HttpGet("designer/templates")]
    public IActionResult DesignerTemplates() => View("~/Views/FlowDesigner/Templates.cshtml");

    [HttpGet("designer/versions/{id:guid}")]
    public IActionResult DesignerVersion(Guid id) { ViewData["VersionId"] = id; return View("~/Views/FlowDesigner/Editor.cshtml"); }

    [HttpGet("instances")]
    public IActionResult Instances() => View("Instances");

    [HttpGet("instances/{id:guid}")]
    public IActionResult InstanceDetail(Guid id) { ViewData["InstanceId"] = id; return View("InstanceDetail"); }

    [HttpGet("tasks")]
    public IActionResult Tasks() => View("Tasks");

    [HttpGet("tasks/{id:guid}")]
    public IActionResult TaskDetail(Guid id) { ViewData["TaskId"] = id; return View("TaskDetail"); }
}
