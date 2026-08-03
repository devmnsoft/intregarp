using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

[Authorize(Roles = "SuperAdmin")]
[Route("superadmin")]
public sealed class SuperAdminController : Controller
{
    [HttpGet("")]
    public IActionResult Index() => View();
}
