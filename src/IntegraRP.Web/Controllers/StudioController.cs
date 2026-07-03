using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class StudioController : Controller
{
    [HttpGet("/studio")]
    [HttpGet("/studio/modules")]
    public IActionResult Index() => View();

    [HttpGet("/studio/modules/create")]
    public IActionResult Create() => View();

    [HttpGet("/studio/modules/{id:guid}")]
    [HttpGet("/studio/modules/{id:guid}/builder")]
    [HttpGet("/studio/modules/{id:guid}/fields")]
    [HttpGet("/studio/modules/{id:guid}/actions")]
    [HttpGet("/studio/modules/{id:guid}/relationships")]
    [HttpGet("/studio/modules/{id:guid}/bpmn")]
    [HttpGet("/studio/modules/{id:guid}/kpis")]
    [HttpGet("/studio/modules/{id:guid}/semantic")]
    [HttpGet("/studio/modules/{id:guid}/publish")]
    public IActionResult Builder(Guid id) => View(id);

    [HttpGet("/studio/smart-builder")]
    public IActionResult SmartBuilder() => View();

    [HttpGet("/studio/import-export")]
    public IActionResult ImportExport() => View();
}
