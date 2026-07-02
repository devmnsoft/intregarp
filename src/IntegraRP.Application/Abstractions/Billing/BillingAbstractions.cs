using IntegraRP.Contracts.Billing;

namespace IntegraRP.Application.Abstractions.Billing;

public interface IBillingService
{
    Task<InvoiceDetailResponse> CreateInvoiceAsync(Guid tenantId, CreateInvoiceRequest request, CancellationToken cancellationToken);
    Task<InvoiceDetailResponse> CreateInvoiceFromOrderAsync(Guid tenantId, Guid orderId, CreateInvoiceFromOrderRequest request, CancellationToken cancellationToken);
    Task<InvoiceDetailResponse?> GetInvoiceAsync(Guid tenantId, Guid id, CancellationToken cancellationToken);
    Task<IReadOnlyList<InvoiceResponse>> ListInvoicesAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken);
    Task<InvoiceDetailResponse> AddInvoiceItemAsync(Guid tenantId, Guid invoiceId, AddInvoiceItemRequest request, CancellationToken cancellationToken);
    Task<InvoiceDetailResponse> IssueInvoiceAsync(Guid tenantId, Guid invoiceId, IssueInvoiceRequest request, CancellationToken cancellationToken);
    Task<FinancialTitleResponse> CreateTitleAsync(Guid tenantId, CreateFinancialTitleRequest request, CancellationToken cancellationToken);
    Task<FinancialTitleResponse> CreateTitleFromInvoiceAsync(Guid tenantId, Guid invoiceId, CreateTitleFromInvoiceRequest request, CancellationToken cancellationToken);
    Task<GenerateFakeBoletoResponse> GenerateBoletoAsync(Guid tenantId, Guid titleId, GenerateFakeBoletoRequest request, CancellationToken cancellationToken);
    Task<BillingDashboardResponse> GetDashboardAsync(Guid tenantId, CancellationToken cancellationToken);
    Task<IReadOnlyList<FinancialTitleResponse>> ListTitlesAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken);
    Task<FinancialTitleResponse?> GetTitleAsync(Guid tenantId, Guid id, CancellationToken cancellationToken);
    Task<FiscalDocumentReferenceResponse> CreateFiscalDocumentAsync(Guid tenantId, CreateFiscalDocumentReferenceRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<FiscalDocumentReferenceResponse>> ListFiscalDocumentsAsync(Guid tenantId, int page, int pageSize, CancellationToken cancellationToken);
    Task<int> MarkOverdueTitlesAsync(CancellationToken cancellationToken);
}

public interface IInvoiceRepository { }
public interface IFinancialTitleRepository { }
public interface IBoletoLogRepository { }
public interface IFiscalDocumentRepository { }
public interface IBillingDocumentRepository { }
public interface ICollectionEventRepository { }
public interface IBillingConfigurationRepository { }
public interface IInvoiceFactory { }
public interface IFinancialTitleService { }
public interface IBoletoProvider { Task<GenerateFakeBoletoResponse> GenerateAsync(Guid titleId, decimal amount, CancellationToken cancellationToken); }
public interface IFiscalDocumentProvider { }
public interface ICollectionService { }
