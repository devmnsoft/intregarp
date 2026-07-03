using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class DynamicController : Controller
{
    [HttpGet("/dynamic/{moduleCode}")]
    public IActionResult List(string moduleCode) => View("List", moduleCode);

    [HttpGet("/dynamic/{moduleCode}/create")]
    public IActionResult Create(string moduleCode) => View(moduleCode);

    [HttpGet("/dynamic/{moduleCode}/{recordId:guid}")]
    [HttpGet("/dynamic/{moduleCode}/{recordId:guid}/edit")]
    [HttpGet("/dynamic/{moduleCode}/{recordId:guid}/history")]
    public IActionResult Detail(string moduleCode, Guid recordId) => View((moduleCode, recordId));
}
