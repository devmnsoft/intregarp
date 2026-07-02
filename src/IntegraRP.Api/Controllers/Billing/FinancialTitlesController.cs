using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Contracts.Billing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Billing;

[ApiController]
[Authorize]
[Route("api/billing/titles")]
public sealed class FinancialTitlesController(IBillingService billingService, ILogger<FinancialTitlesController> logger) : IntegraControllerBase
{
    [HttpGet]
    public async Task<IActionResult> List([FromQuery] string? status, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken cancellationToken = default)
    {
        try { return Ok(await billingService.ListTitlesAsync(TenantId, status, page, pageSize, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "listar títulos"); }
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> Get(Guid id, CancellationToken cancellationToken)
    {
        try { return (await billingService.GetTitleAsync(TenantId, id, cancellationToken)) is { } title ? Ok(title) : NotFound(); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "obter título"); }
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateFinancialTitleRequest request, CancellationToken cancellationToken)
    {
        try { return Ok(await billingService.CreateTitleAsync(TenantId, request, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "criar título"); }
    }

    [HttpPost("from-invoice/{invoiceId:guid}")]
    public async Task<IActionResult> FromInvoice(Guid invoiceId, CreateTitleFromInvoiceRequest request, CancellationToken cancellationToken)
    {
        try { return Ok(await billingService.CreateTitleFromInvoiceAsync(TenantId, invoiceId, request, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "criar título da fatura"); }
    }

    [HttpPost("{id:guid}/generate-boleto")]
    public async Task<IActionResult> GenerateBoleto(Guid id, GenerateFakeBoletoRequest request, CancellationToken cancellationToken)
    {
        try { return Ok(await billingService.GenerateBoletoAsync(TenantId, id, request, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "gerar boleto fake"); }
    }

    [HttpPost("{id:guid}/send")] public IActionResult Send(Guid id, SendFinancialTitleRequest request) => Ok(new { id, status = "enviado", request.Canal });
    [HttpPost("{id:guid}/payment")] public IActionResult Payment(Guid id, RegisterTitlePaymentRequest request) => Ok(new { id, status = "pago", request.ValorPago });
    [HttpPost("{id:guid}/cancel")] public IActionResult Cancel(Guid id, CancelFinancialTitleRequest request) => Ok(new { id, status = "cancelado", request.Motivo });
}
