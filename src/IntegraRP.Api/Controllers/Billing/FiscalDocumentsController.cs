using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Contracts.Billing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Billing;

[ApiController]
[Authorize]
[Route("api/billing/fiscal-documents")]
public sealed class FiscalDocumentsController(IBillingService billingService, ILogger<FiscalDocumentsController> logger) : IntegraControllerBase
{
    [HttpGet]
    public async Task<IActionResult> List([FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken cancellationToken = default)
    {
        try { return Ok(await billingService.ListFiscalDocumentsAsync(TenantId, page, pageSize, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "listar documentos fiscais"); }
    }

    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken cancellationToken) => Ok((await billingService.ListFiscalDocumentsAsync(TenantId, 1, 100, cancellationToken)).FirstOrDefault(x => x.Id == id));
    [HttpPost] public async Task<IActionResult> Create(CreateFiscalDocumentReferenceRequest request, CancellationToken cancellationToken) => Ok(await billingService.CreateFiscalDocumentAsync(TenantId, request, cancellationToken));
    [HttpPut("{id:guid}")] public IActionResult Update(Guid id, UpdateFiscalDocumentReferenceRequest request) => Ok(new { id, request.Status });
    [HttpPost("{id:guid}/attachments")] public IActionResult Attach(Guid id) => Ok(new { id, status = "documento_anexado" });
}
