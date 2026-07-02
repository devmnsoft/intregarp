namespace IntegraRP.Domain.Billing;

public enum InvoiceStatus { Rascunho, Emitida, Enviada, Cancelada, PagaParcial, Paga, Vencida }
public enum FinancialTitleType { Receber, Pagar }
public enum FinancialTitleStatus { Aberto, Enviado, Pago, PagoParcial, Vencido, Cancelado, Renegociado }
public enum BoletoStatus { Gerado, Erro, Cancelado }
public enum FiscalDocumentType { Nfe, Nfse, Nfce, Outro }
public enum FiscalDocumentStatus { Pendente, Referenciada, AutorizadaFake, ErroFake, Cancelada }
public enum CollectionEventType { Vencendo, Vencido, Enviado, Pago, Cancelado }

public readonly record struct Money(decimal Value)
{
    public static Money Zero => new(0);
    public static Money Of(decimal value) => new(decimal.Round(value, 2));
}

public readonly record struct DueDate
{
    public DateOnly Value { get; }
    public DueDate(DateOnly value)
    {
        if (value == default) throw new ArgumentException("Data de vencimento é obrigatória.", nameof(value));
        Value = value;
    }
}

public readonly record struct InvoiceCode
{
    public string Value { get; }
    public InvoiceCode(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) throw new ArgumentException("Código da fatura é obrigatório.", nameof(value));
        Value = value.Trim();
    }
}

public readonly record struct FinancialTitleCode
{
    public string Value { get; }
    public FinancialTitleCode(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) throw new ArgumentException("Código do título é obrigatório.", nameof(value));
        Value = value.Trim();
    }
}

public readonly record struct FakeBarcode(string Value);
public readonly record struct FakeLinhaDigitavel(string Value);

public sealed class Invoice
{
    private readonly List<InvoiceItem> _items = [];
    public Guid Id { get; } = Guid.NewGuid();
    public Guid TenantId { get; }
    public Guid? OrderId { get; }
    public Guid CustomerId { get; }
    public string Code { get; }
    public InvoiceStatus Status { get; private set; } = InvoiceStatus.Rascunho;
    public decimal GrossAmount { get; private set; }
    public decimal DiscountAmount { get; private set; }
    public decimal TotalAmount { get; private set; }
    public IReadOnlyCollection<InvoiceItem> Items => _items;

    public Invoice(Guid tenantId, Guid customerId, string code, Guid? orderId = null)
    {
        if (tenantId == Guid.Empty) throw new ArgumentException("Tenant é obrigatório.", nameof(tenantId));
        if (customerId == Guid.Empty) throw new ArgumentException("Fatura precisa ter cliente.", nameof(customerId));
        TenantId = tenantId;
        CustomerId = customerId;
        Code = new InvoiceCode(code).Value;
        OrderId = orderId;
    }

    public void AddItem(InvoiceItem item)
    {
        if (Status != InvoiceStatus.Rascunho) throw new InvalidOperationException("Fatura emitida não pode alterar itens.");
        _items.Add(item);
        Recalculate();
    }

    public void Issue()
    {
        if (_items.Count == 0) throw new InvalidOperationException("Fatura precisa ter pelo menos um item.");
        Recalculate();
        Status = InvoiceStatus.Emitida;
    }

    public void Cancel() => Status = InvoiceStatus.Cancelada;

    private void Recalculate()
    {
        GrossAmount = _items.Sum(i => i.Quantity * i.UnitAmount);
        DiscountAmount = _items.Sum(i => i.DiscountAmount);
        TotalAmount = _items.Sum(i => i.TotalAmount);
    }
}

public sealed record InvoiceItem(Guid Id, string Description, decimal Quantity, decimal UnitAmount, decimal DiscountAmount)
{
    public decimal TotalAmount => decimal.Round((Quantity * UnitAmount) - DiscountAmount, 2);
}

public sealed class FinancialTitle
{
    public Guid Id { get; } = Guid.NewGuid();
    public Guid TenantId { get; }
    public Guid CustomerId { get; }
    public string Code { get; }
    public FinancialTitleStatus Status { get; private set; } = FinancialTitleStatus.Aberto;
    public DateOnly DueDate { get; }
    public decimal OriginalAmount { get; }
    public decimal DiscountAmount { get; private set; }
    public decimal IncreaseAmount { get; private set; }
    public decimal PaidAmount { get; private set; }
    public decimal OpenAmount => decimal.Round(OriginalAmount + IncreaseAmount - DiscountAmount - PaidAmount, 2);

    public FinancialTitle(Guid tenantId, Guid customerId, string code, DateOnly dueDate, decimal originalAmount)
    {
        if (tenantId == Guid.Empty) throw new ArgumentException("Tenant é obrigatório.", nameof(tenantId));
        if (customerId == Guid.Empty) throw new ArgumentException("Cliente é obrigatório.", nameof(customerId));
        if (originalAmount <= 0) throw new ArgumentException("Valor original deve ser positivo.", nameof(originalAmount));
        TenantId = tenantId;
        CustomerId = customerId;
        Code = new FinancialTitleCode(code).Value;
        DueDate = new DueDate(dueDate).Value;
        OriginalAmount = originalAmount;
    }

    public void RegisterPayment(decimal amount)
    {
        if (Status == FinancialTitleStatus.Pago) throw new InvalidOperationException("Título pago não pode receber baixa novamente.");
        if (Status == FinancialTitleStatus.Cancelado) throw new InvalidOperationException("Título cancelado não pode receber baixa.");
        PaidAmount += amount;
        Status = OpenAmount <= 0 ? FinancialTitleStatus.Pago : FinancialTitleStatus.PagoParcial;
    }

    public void Send()
    {
        if (Status == FinancialTitleStatus.Cancelado) throw new InvalidOperationException("Título cancelado não pode ser enviado.");
        Status = FinancialTitleStatus.Enviado;
    }

    public void MarkOverdue(DateOnly today)
    {
        if ((Status == FinancialTitleStatus.Aberto || Status == FinancialTitleStatus.Enviado) && DueDate < today) Status = FinancialTitleStatus.Vencido;
    }

    public void Cancel() => Status = FinancialTitleStatus.Cancelado;
}

public sealed record FinancialTitleHistory(Guid Id, Guid TitleId, string EventType, string Description, DateTimeOffset CreatedAt);
public sealed record BoletoLog(Guid Id, Guid TenantId, Guid TitleId, BoletoStatus Status, string LinkBoleto, string LinhaDigitavel, string CodigoBarras, string? Error);
public sealed record FiscalDocumentReference(Guid Id, Guid TenantId, Guid CustomerId, FiscalDocumentType Type, FiscalDocumentStatus Status, string? Number, string? AccessKey);
public sealed record BillingDocument(Guid Id, Guid TenantId, Guid? FiscalDocumentReferenceId, string Name, string StorageKey);
public sealed record CollectionEvent(Guid Id, Guid TenantId, Guid TitleId, CollectionEventType Type, string Description);
public sealed record BillingConfiguration(Guid TenantId, int DefaultDueDays, bool AllowFakeBoleto, bool AllowFakeFiscalDocument);
