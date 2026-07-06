using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class OperationalController : Controller
{
    [HttpGet("operational/templates")] public IActionResult Templates() => View();
    [HttpGet("operational/templates/packages")] public IActionResult Packages() => View("Templates");
    [HttpGet("operational/templates/{id:guid}")] public IActionResult TemplateDetail(Guid id) => View("Templates", id);
    [HttpGet("operational/templates/installations")] public IActionResult Installations() => View("Templates");
    [HttpGet("operations")] public IActionResult Operations() => View();
    [HttpGet("operations/routes")] public IActionResult Routes() => View();
    [HttpGet("operations/routes/create")] public IActionResult CreateRoute() => View("Routes");
    [HttpGet("operations/routes/{id:guid}")] public IActionResult RouteDetail(Guid id) => View("Routes", id);
    [HttpGet("operations/manifests")] public IActionResult Manifests() => View();
    [HttpGet("operations/manifests/create")] public IActionResult CreateManifest() => View("Manifests");
    [HttpGet("operations/manifests/{id:guid}")] public IActionResult ManifestDetail(Guid id) => View("Manifests", id);
    [HttpGet("operations/deliveries")] public IActionResult Deliveries() => View("DeliveryMonitoring");
    [HttpGet("operations/deliveries/monitoring")] public IActionResult DeliveryMonitoring() => View();
    [HttpGet("operations/deliveries/occurrences")] public IActionResult DeliveryOccurrences() => View();
    [HttpGet("operations/deliveries/pod")] public IActionResult ProofOfDelivery() => View();
}
