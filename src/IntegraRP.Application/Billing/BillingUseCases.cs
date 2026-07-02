using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Application.Common;
using IntegraRP.Contracts.Billing;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.Billing;

public abstract class BillingUseCaseBase<T>(ILogger logger)
{
    protected async Task<Result<T>> RunAsync(Func<Task<T>> action)
    {
        try { return Result<T>.Success(await action()); }
        catch (Exception ex) { logger.LogError(ex, "Falha no caso de uso de faturamento."); return Result<T>.Failure(ex.Message); }
    }
}

public sealed class CreateInvoiceUseCase(IBillingService service, ILogger<CreateInvoiceUseCase> logger) : BillingUseCaseBase<InvoiceDetailResponse>(logger)
{ public Task<Result<InvoiceDetailResponse>> ExecuteAsync(Guid tenantId, CreateInvoiceRequest request, CancellationToken ct) => RunAsync(() => service.CreateInvoiceAsync(tenantId, request, ct)); }
public sealed class CreateInvoiceFromOrderUseCase(IBillingService service, ILogger<CreateInvoiceFromOrderUseCase> logger) : BillingUseCaseBase<InvoiceDetailResponse>(logger)
{ public Task<Result<InvoiceDetailResponse>> ExecuteAsync(Guid tenantId, Guid orderId, CreateInvoiceFromOrderRequest request, CancellationToken ct) => RunAsync(() => service.CreateInvoiceFromOrderAsync(tenantId, orderId, request, ct)); }
public sealed class AddInvoiceItemUseCase(IBillingService service, ILogger<AddInvoiceItemUseCase> logger) : BillingUseCaseBase<InvoiceDetailResponse>(logger)
{ public Task<Result<InvoiceDetailResponse>> ExecuteAsync(Guid tenantId, Guid invoiceId, AddInvoiceItemRequest request, CancellationToken ct) => RunAsync(() => service.AddInvoiceItemAsync(tenantId, invoiceId, request, ct)); }
public sealed class IssueInvoiceUseCase(IBillingService service, ILogger<IssueInvoiceUseCase> logger) : BillingUseCaseBase<InvoiceDetailResponse>(logger)
{ public Task<Result<InvoiceDetailResponse>> ExecuteAsync(Guid tenantId, Guid invoiceId, IssueInvoiceRequest request, CancellationToken ct) => RunAsync(() => service.IssueInvoiceAsync(tenantId, invoiceId, request, ct)); }
public sealed class CancelInvoiceUseCase(ILogger<CancelInvoiceUseCase> logger) : BillingUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid invoiceId, CancelInvoiceRequest request, CancellationToken ct) => RunAsync(() => Task.FromResult("cancelada")); }
public sealed class GetInvoiceByIdUseCase(IBillingService service, ILogger<GetInvoiceByIdUseCase> logger) : BillingUseCaseBase<InvoiceDetailResponse?>(logger)
{ public Task<Result<InvoiceDetailResponse?>> ExecuteAsync(Guid tenantId, Guid invoiceId, CancellationToken ct) => RunAsync(() => service.GetInvoiceAsync(tenantId, invoiceId, ct)); }
public sealed class ListInvoicesUseCase(IBillingService service, ILogger<ListInvoicesUseCase> logger) : BillingUseCaseBase<IReadOnlyList<InvoiceResponse>>(logger)
{ public Task<Result<IReadOnlyList<InvoiceResponse>>> ExecuteAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken ct) => RunAsync(() => service.ListInvoicesAsync(tenantId, status, page, pageSize, ct)); }
public sealed class CreateFinancialTitleUseCase(IBillingService service, ILogger<CreateFinancialTitleUseCase> logger) : BillingUseCaseBase<FinancialTitleResponse>(logger)
{ public Task<Result<FinancialTitleResponse>> ExecuteAsync(Guid tenantId, CreateFinancialTitleRequest request, CancellationToken ct) => RunAsync(() => service.CreateTitleAsync(tenantId, request, ct)); }
public sealed class CreateTitleFromInvoiceUseCase(IBillingService service, ILogger<CreateTitleFromInvoiceUseCase> logger) : BillingUseCaseBase<FinancialTitleResponse>(logger)
{ public Task<Result<FinancialTitleResponse>> ExecuteAsync(Guid tenantId, Guid invoiceId, CreateTitleFromInvoiceRequest request, CancellationToken ct) => RunAsync(() => service.CreateTitleFromInvoiceAsync(tenantId, invoiceId, request, ct)); }
public sealed class GetFinancialTitleByIdUseCase(IBillingService service, ILogger<GetFinancialTitleByIdUseCase> logger) : BillingUseCaseBase<FinancialTitleResponse?>(logger)
{ public Task<Result<FinancialTitleResponse?>> ExecuteAsync(Guid tenantId, Guid titleId, CancellationToken ct) => RunAsync(() => service.GetTitleAsync(tenantId, titleId, ct)); }
public sealed class ListFinancialTitlesUseCase(IBillingService service, ILogger<ListFinancialTitlesUseCase> logger) : BillingUseCaseBase<IReadOnlyList<FinancialTitleResponse>>(logger)
{ public Task<Result<IReadOnlyList<FinancialTitleResponse>>> ExecuteAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken ct) => RunAsync(() => service.ListTitlesAsync(tenantId, status, page, pageSize, ct)); }
public sealed class GenerateFakeBoletoUseCase(IBillingService service, ILogger<GenerateFakeBoletoUseCase> logger) : BillingUseCaseBase<GenerateFakeBoletoResponse>(logger)
{ public Task<Result<GenerateFakeBoletoResponse>> ExecuteAsync(Guid tenantId, Guid titleId, GenerateFakeBoletoRequest request, CancellationToken ct) => RunAsync(() => service.GenerateBoletoAsync(tenantId, titleId, request, ct)); }
public sealed class SendFinancialTitleUseCase(ILogger<SendFinancialTitleUseCase> logger) : BillingUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid titleId, SendFinancialTitleRequest request, CancellationToken ct) => RunAsync(() => Task.FromResult("enviado")); }
public sealed class RegisterTitlePaymentUseCase(ILogger<RegisterTitlePaymentUseCase> logger) : BillingUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid titleId, RegisterTitlePaymentRequest request, CancellationToken ct) => RunAsync(() => Task.FromResult("pago")); }
public sealed class CancelFinancialTitleUseCase(ILogger<CancelFinancialTitleUseCase> logger) : BillingUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid titleId, CancelFinancialTitleRequest request, CancellationToken ct) => RunAsync(() => Task.FromResult("cancelado")); }
public sealed class MarkOverdueTitlesUseCase(IBillingService service, ILogger<MarkOverdueTitlesUseCase> logger) : BillingUseCaseBase<int>(logger)
{ public Task<Result<int>> ExecuteAsync(CancellationToken ct) => RunAsync(() => service.MarkOverdueTitlesAsync(ct)); }
public sealed class CreateFiscalDocumentReferenceUseCase(IBillingService service, ILogger<CreateFiscalDocumentReferenceUseCase> logger) : BillingUseCaseBase<FiscalDocumentReferenceResponse>(logger)
{ public Task<Result<FiscalDocumentReferenceResponse>> ExecuteAsync(Guid tenantId, CreateFiscalDocumentReferenceRequest request, CancellationToken ct) => RunAsync(() => service.CreateFiscalDocumentAsync(tenantId, request, ct)); }
public sealed class UpdateFiscalDocumentReferenceUseCase(ILogger<UpdateFiscalDocumentReferenceUseCase> logger) : BillingUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid id, UpdateFiscalDocumentReferenceRequest request, CancellationToken ct) => RunAsync(() => Task.FromResult(request.Status)); }
public sealed class AttachBillingDocumentUseCase(ILogger<AttachBillingDocumentUseCase> logger) : BillingUseCaseBase<string>(logger)
{ public Task<Result<string>> ExecuteAsync(Guid tenantId, Guid id, CancellationToken ct) => RunAsync(() => Task.FromResult("anexado")); }
public sealed class ListFiscalDocumentsUseCase(IBillingService service, ILogger<ListFiscalDocumentsUseCase> logger) : BillingUseCaseBase<IReadOnlyList<FiscalDocumentReferenceResponse>>(logger)
{ public Task<Result<IReadOnlyList<FiscalDocumentReferenceResponse>>> ExecuteAsync(Guid tenantId, int page, int pageSize, CancellationToken ct) => RunAsync(() => service.ListFiscalDocumentsAsync(tenantId, page, pageSize, ct)); }
public sealed class GetBillingDashboardUseCase(IBillingService service, ILogger<GetBillingDashboardUseCase> logger) : BillingUseCaseBase<BillingDashboardResponse>(logger)
{ public Task<Result<BillingDashboardResponse>> ExecuteAsync(Guid tenantId, CancellationToken ct) => RunAsync(() => service.GetDashboardAsync(tenantId, ct)); }
