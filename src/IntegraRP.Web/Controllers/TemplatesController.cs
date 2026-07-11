using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class TemplatesController : Controller
{
    [HttpGet("templates")]
    public IActionResult Index() => View();

    [HttpGet("templates/{id:guid}")]
    public IActionResult Detail(Guid id) => View("Index", id);

    [HttpGet("templates/{id:guid}/install")]
    public IActionResult Install(Guid id) => View("Index", id);
}
