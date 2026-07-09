using IntegraRP.Application.OperationalTemplates;
using IntegraRP.Contracts.OperationalTemplates;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/operational/templates")]
[Route("api/templates")]
public sealed class OperationalTemplatesController(ListOperationalTemplatePackagesUseCase packages, ListOperationalTemplatesUseCase templates, GetOperationalTemplateByIdUseCase getTemplate, PreviewOperationalTemplateUseCase preview, InstallOperationalTemplateUseCase installTemplate, InstallOperationalTemplatePackageUseCase installPackage, ListOperationalTemplateInstallationsUseCase installations, GetOperationalTemplateInstallationLogUseCase logs, ILogger<OperationalTemplatesController> logger) : IntegraControllerBase
{
    [HttpGet("packages")] public async Task<IActionResult> GetPackages(CancellationToken ct) { try { var r = await packages.ExecuteAsync(TenantId, ct); return r.IsSuccess ? Ok(r.Value) : Problem(r.Error); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetPackages)); } }
    [HttpGet] public async Task<IActionResult> GetTemplates(CancellationToken ct) { try { var r = await templates.ExecuteAsync(TenantId, ct); return r.IsSuccess ? Ok(r.Value) : Problem(r.Error); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetTemplates)); } }
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) { try { var r = await getTemplate.ExecuteAsync(TenantId, id, ct); return r.Value is null ? NotFound() : Ok(r.Value); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } }
    [HttpPost("{id:guid}/preview")] public async Task<IActionResult> Preview(Guid id, [FromBody] OperationalTemplatePreviewRequest request, CancellationToken ct) { try { var r = await preview.ExecuteAsync(TenantId, id, ct); return r.IsSuccess ? Ok(r.Value) : Problem(r.Error); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Preview)); } }
    [HttpPost("{id:guid}/install")] public async Task<IActionResult> Install(Guid id, [FromBody] InstallOperationalTemplateRequest request, CancellationToken ct) { try { var r = await installTemplate.ExecuteAsync(TenantId, id, request.UsuarioId, request.Configuracao, ct); return r.IsSuccess ? Ok(r.Value) : Problem(r.Error); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Install)); } }
    [HttpPost("packages/{id:guid}/install")] public async Task<IActionResult> InstallPackage(Guid id, [FromBody] InstallOperationalTemplateRequest request, CancellationToken ct) { try { var r = await installPackage.ExecuteAsync(TenantId, id, request.UsuarioId, request.Configuracao, ct); return r.IsSuccess ? Ok(r.Value) : Problem(r.Error); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(InstallPackage)); } }
    [HttpGet("installations")] public async Task<IActionResult> Installations(CancellationToken ct) { try { var r = await installations.ExecuteAsync(TenantId, ct); return r.IsSuccess ? Ok(r.Value) : Problem(r.Error); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Installations)); } }
    [HttpGet("installations/{id:guid}/logs")] public async Task<IActionResult> Logs(Guid id, CancellationToken ct) { try { var r = await logs.ExecuteAsync(TenantId, id, ct); return r.IsSuccess ? Ok(r.Value) : Problem(r.Error); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Logs)); } }
}
