using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class JourneyController : Controller
{
    [HttpGet("getting-started")] public IActionResult GettingStarted() => View("Index");
    [HttpGet("journey")] public IActionResult Index() => View();
    [HttpGet("journey/what-to-do-now")] public IActionResult WhatToDoNow() => View();
    [HttpGet("journey/help")] public IActionResult Help() => View();
    [HttpGet("journey/tours")] public IActionResult Tours() => View();
    [HttpGet("journey/feedback")] public IActionResult Feedback() => View();
}
