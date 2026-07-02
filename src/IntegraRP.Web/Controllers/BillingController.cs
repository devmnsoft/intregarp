using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

public sealed class BillingController : Controller
{
    [Route("billing")]
    public IActionResult Index() => View();
    [Route("billing/invoices")]
    public IActionResult Invoices() => View();
    [Route("billing/invoices/create")]
    public IActionResult CreateInvoice() => View();
    [Route("billing/invoices/{id:guid}")] public IActionResult InvoiceDetail(Guid id) => View(id);
    [Route("billing/titles")]
    public IActionResult Titles() => View();
    [Route("billing/titles/{id:guid}")] public IActionResult TitleDetail(Guid id) => View(id);
    [Route("billing/fiscal-documents")] public IActionResult FiscalDocuments() => View();
    [Route("billing/fiscal-documents/{id:guid}")] public IActionResult FiscalDocumentDetail(Guid id) => View(id);
}
