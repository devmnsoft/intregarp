using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class AiController : Controller
{
    [HttpGet("/ai")] public IActionResult Index() => View("~/Views/Ai/Index.cshtml");
    [HttpGet("/ai/chat")] public IActionResult Chat() => View("~/Views/Ai/Chat.cshtml");
    [HttpGet("/ai/conversations")] public IActionResult Conversations() => View("~/Views/Ai/Conversations.cshtml");
    [HttpGet("/ai/audit")] public IActionResult Audit() => View("~/Views/Ai/Audit.cshtml");
    [HttpGet("/ai/audit/{id}")] public IActionResult AuditDetail(Guid id) => View("~/Views/Ai/AuditDetail.cshtml", id);
    [HttpGet("/ai/tools")] public IActionResult Tools() => View("~/Views/Ai/Tools.cshtml");
    [HttpGet("/ai/escalations")] public IActionResult Escalations() => View("~/Views/Ai/Escalations.cshtml");
}
