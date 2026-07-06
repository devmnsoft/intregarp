using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class V12WebController : Controller
{
    [Route("integrations/{**path}")] public IActionResult Integrations() => View("V12", "Integrações v1.2");
    [Route("fiscal/{**path}")] public IActionResult Fiscal() => View("V12", "Fiscal Fake/Sandbox v1.2");
    [Route("reconciliation/{**path}")] public IActionResult Reconciliation() => View("V12", "Conciliação Financeira v1.2");
    [Route("routing/{**path}")] public IActionResult Routing() => View("V12", "Rotas Otimizadas v1.2");
    [Route("offline/{**path}")] public IActionResult Offline() => View("V12", "Offline Robusto v1.2");
}
