using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class ConnectController : Controller
{
    [Route("connect")]
    public IActionResult Index() => View();
    [Route("connect/templates")]
    public IActionResult Templates() => View();
    [Route("connect/templates/create")] public IActionResult CreateTemplate() => View();
    [Route("connect/templates/{id:guid}")] public IActionResult TemplateDetail(Guid id) => View(id);
    [Route("connect/messages")]
    public IActionResult Messages() => View();
    [Route("connect/outbox")]
    public IActionResult Outbox() => View();
    [Route("connect/outbox/{id:guid}")] public IActionResult OutboxDetail(Guid id) => View(id);
    [Route("connect/conversations")]
    public IActionResult Conversations() => View();
}
