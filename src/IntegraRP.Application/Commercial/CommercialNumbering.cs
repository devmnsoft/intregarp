namespace IntegraRP.Application.Commercial;

public enum CommercialDocumentType { Quote, Order }

public interface ICommercialNumberRepository
{
    Task<string> NextAsync(Guid tenantId, CommercialDocumentType documentType, int year, CancellationToken cancellationToken);
}

public sealed class NumeracaoComercialService(ICommercialNumberRepository repository)
{
    public Task<string> GenerateQuoteNumberAsync(Guid tenantId, int year, CancellationToken cancellationToken) => GenerateAsync(tenantId, CommercialDocumentType.Quote, year, cancellationToken);
    public Task<string> GenerateOrderNumberAsync(Guid tenantId, int year, CancellationToken cancellationToken) => GenerateAsync(tenantId, CommercialDocumentType.Order, year, cancellationToken);

    private Task<string> GenerateAsync(Guid tenantId, CommercialDocumentType type, int year, CancellationToken cancellationToken)
    {
        if (tenantId == Guid.Empty) throw new ArgumentException("Tenant obrigatório.", nameof(tenantId));
        if (year is < 2000 or > 9999) throw new ArgumentOutOfRangeException(nameof(year));
        return repository.NextAsync(tenantId, type, year, cancellationToken);
    }
}
