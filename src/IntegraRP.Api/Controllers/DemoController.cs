using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/demo")]
public sealed class DemoController : ControllerBase
{
    [HttpGet("status")] public IActionResult Status() => Ok(new { status="ok", steps=DemoData.Steps });
    [HttpPost("reset")] public IActionResult Reset() => Ok(new { status="ok", etapa="reset", mensagem="Demo preservada; reaplique scriptcompleto para reset físico." });
    [HttpPost("run-step/{stepCode}")] public IActionResult RunStep(string stepCode) => Ok(new { status="ok", etapa=stepCode, mensagem="Etapa validada com dados demo v1.9." });
    [HttpPost("run-all")] public IActionResult RunAll() => Ok(new { status="ok", etapa="run-all", steps=DemoData.Steps, proximaAcao="Acompanhar dashboard" });
}
