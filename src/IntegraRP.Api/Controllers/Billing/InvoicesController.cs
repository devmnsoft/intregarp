using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Contracts.Billing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Billing;

[ApiController]
[Authorize]
[Route("api/billing/invoices")]
public sealed class InvoicesController(IBillingService billingService, ILogger<InvoicesController> logger) : IntegraControllerBase
{
    [HttpGet]
    public async Task<IActionResult> List([FromQuery] string? status, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken cancellationToken = default)
    {
        try { return Ok(await billingService.ListInvoicesAsync(TenantId, status, page, pageSize, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "listar faturas"); }
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> Get(Guid id, CancellationToken cancellationToken)
    {
        try { return (await billingService.GetInvoiceAsync(TenantId, id, cancellationToken)) is { } invoice ? Ok(invoice) : NotFound(); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "obter fatura"); }
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateInvoiceRequest request, CancellationToken cancellationToken)
    {
        try { var invoice = await billingService.CreateInvoiceAsync(TenantId, request, cancellationToken); return CreatedAtAction(nameof(Get), new { id = invoice.Invoice.Id }, invoice); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "criar fatura"); }
    }

    [HttpPost("from-order/{orderId:guid}")]
    public async Task<IActionResult> FromOrder(Guid orderId, CreateInvoiceFromOrderRequest request, CancellationToken cancellationToken)
    {
        try { return Ok(await billingService.CreateInvoiceFromOrderAsync(TenantId, orderId, request, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "criar fatura do pedido"); }
    }

    [HttpPost("{id:guid}/items")]
    public async Task<IActionResult> AddItem(Guid id, AddInvoiceItemRequest request, CancellationToken cancellationToken)
    {
        try { return Ok(await billingService.AddInvoiceItemAsync(TenantId, id, request, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "adicionar item da fatura"); }
    }

    [HttpPost("{id:guid}/issue")]
    public async Task<IActionResult> Issue(Guid id, IssueInvoiceRequest request, CancellationToken cancellationToken)
    {
        try { return Ok(await billingService.IssueInvoiceAsync(TenantId, id, request, cancellationToken)); }
        catch (Exception ex) { return ProblemFrom(ex, logger, "emitir fatura"); }
    }

    [HttpPost("{id:guid}/cancel")]
    public IActionResult Cancel(Guid id, CancelInvoiceRequest request) => Ok(new { id, status = "cancelada", request.Motivo });
}
