using IntegraRP.Contracts.Commercial;

namespace IntegraRP.Application.Commercial;

public interface ICommercialOperationsRepository
{
    Task<IReadOnlyList<CustomerContactDto>> ListContactsAsync(Guid tenantId, Guid customerId, CancellationToken ct);
    Task<CustomerContactDto> AddContactAsync(Guid tenantId, Guid userId, Guid customerId, SaveCustomerContactRequest request, CancellationToken ct);
    Task<CustomerContactDto> UpdateContactAsync(Guid tenantId, Guid userId, Guid customerId, Guid contactId, SaveCustomerContactRequest request, CancellationToken ct);
    Task DeleteContactAsync(Guid tenantId, Guid userId, Guid customerId, Guid contactId, long rowVersion, CancellationToken ct);
    Task<IReadOnlyList<CustomerAddressDto>> ListAddressesAsync(Guid tenantId, Guid customerId, CancellationToken ct);
    Task<CustomerAddressDto> AddAddressAsync(Guid tenantId, Guid userId, Guid customerId, SaveCustomerAddressRequest request, CancellationToken ct);
    Task<CustomerAddressDto> UpdateAddressAsync(Guid tenantId, Guid userId, Guid customerId, Guid addressId, SaveCustomerAddressRequest request, CancellationToken ct);
    Task DeleteAddressAsync(Guid tenantId, Guid userId, Guid customerId, Guid addressId, long rowVersion, CancellationToken ct);
    Task<IReadOnlyList<OpportunityDto>> ListOpportunitiesAsync(Guid tenantId, CancellationToken ct);
    Task<OpportunityDto> CreateOpportunityAsync(Guid tenantId, Guid userId, CreateOpportunityRequest request, string correlationId, CancellationToken ct);
    Task<OpportunityDto> ChangeOpportunityStageAsync(Guid tenantId, Guid userId, Guid id, ChangeOpportunityStageRequest request, string correlationId, CancellationToken ct);
    Task<IReadOnlyList<QuoteDto>> ListQuotesAsync(Guid tenantId, CancellationToken ct);
    Task<QuoteDto> GetQuoteAsync(Guid tenantId, Guid id, CancellationToken ct);
    Task<QuoteDto> CreateQuoteAsync(Guid tenantId, Guid userId, CreateQuoteRequest request, string correlationId, CancellationToken ct);
    Task<QuoteDto> AddQuoteItemAsync(Guid tenantId, Guid userId, Guid id, AddQuoteItemRequest request, string correlationId, CancellationToken ct);
    Task<QuoteDto> ApplyQuoteDiscountAsync(Guid tenantId, Guid userId, Guid id, ApplyQuoteDiscountRequest request, string correlationId, CancellationToken ct);
    Task<QuoteDto> SubmitQuoteAsync(Guid tenantId, Guid userId, Guid id, QuoteDecisionRequest request, string correlationId, CancellationToken ct);
    Task<QuoteDto> DecideQuoteAsync(Guid tenantId, Guid userId, Guid id, bool approve, QuoteDecisionRequest request, string correlationId, CancellationToken ct);
}

public sealed class CommercialOperationsUseCases(ICommercialOperationsRepository repository)
{
    private static void Context(Guid tenantId, Guid userId) { if (tenantId == Guid.Empty || userId == Guid.Empty) throw new UnauthorizedAccessException("Tenant e usuário autenticados são obrigatórios."); }
    public Task<IReadOnlyList<CustomerContactDto>> ListContactsAsync(Guid tenantId, Guid customerId, CancellationToken ct) => repository.ListContactsAsync(tenantId, customerId, ct);
    public Task<CustomerContactDto> AddContactAsync(Guid tenantId, Guid userId, Guid customerId, SaveCustomerContactRequest request, CancellationToken ct) { Context(tenantId,userId); return repository.AddContactAsync(tenantId,userId,customerId,request,ct); }
    public Task<CustomerContactDto> UpdateContactAsync(Guid tenantId, Guid userId, Guid customerId, Guid id, SaveCustomerContactRequest request, CancellationToken ct) { Context(tenantId,userId); return repository.UpdateContactAsync(tenantId,userId,customerId,id,request,ct); }
    public Task DeleteContactAsync(Guid tenantId, Guid userId, Guid customerId, Guid id, long version, CancellationToken ct) { Context(tenantId,userId); return repository.DeleteContactAsync(tenantId,userId,customerId,id,version,ct); }
    public Task<IReadOnlyList<CustomerAddressDto>> ListAddressesAsync(Guid tenantId, Guid customerId, CancellationToken ct) => repository.ListAddressesAsync(tenantId,customerId,ct);
    public Task<CustomerAddressDto> AddAddressAsync(Guid tenantId, Guid userId, Guid customerId, SaveCustomerAddressRequest request, CancellationToken ct) { Context(tenantId,userId); return repository.AddAddressAsync(tenantId,userId,customerId,request,ct); }
    public Task<CustomerAddressDto> UpdateAddressAsync(Guid tenantId, Guid userId, Guid customerId, Guid id, SaveCustomerAddressRequest request, CancellationToken ct) { Context(tenantId,userId); return repository.UpdateAddressAsync(tenantId,userId,customerId,id,request,ct); }
    public Task DeleteAddressAsync(Guid tenantId, Guid userId, Guid customerId, Guid id, long version, CancellationToken ct) { Context(tenantId,userId); return repository.DeleteAddressAsync(tenantId,userId,customerId,id,version,ct); }
    public Task<IReadOnlyList<OpportunityDto>> ListOpportunitiesAsync(Guid tenantId, CancellationToken ct) => repository.ListOpportunitiesAsync(tenantId,ct);
    public Task<OpportunityDto> CreateOpportunityAsync(Guid tenantId, Guid userId, CreateOpportunityRequest request, string correlationId, CancellationToken ct) { Context(tenantId,userId); return repository.CreateOpportunityAsync(tenantId,userId,request,correlationId,ct); }
    public Task<OpportunityDto> ChangeStageAsync(Guid tenantId, Guid userId, Guid id, ChangeOpportunityStageRequest request, string correlationId, CancellationToken ct) { Context(tenantId,userId); return repository.ChangeOpportunityStageAsync(tenantId,userId,id,request,correlationId,ct); }
    public Task<IReadOnlyList<QuoteDto>> ListQuotesAsync(Guid tenantId, CancellationToken ct) => repository.ListQuotesAsync(tenantId,ct);
    public Task<QuoteDto> GetQuoteAsync(Guid tenantId, Guid id, CancellationToken ct) => repository.GetQuoteAsync(tenantId,id,ct);
    public Task<QuoteDto> CreateQuoteAsync(Guid tenantId, Guid userId, CreateQuoteRequest request, string correlationId, CancellationToken ct) { Context(tenantId,userId); return repository.CreateQuoteAsync(tenantId,userId,request,correlationId,ct); }
    public Task<QuoteDto> AddQuoteItemAsync(Guid tenantId, Guid userId, Guid id, AddQuoteItemRequest request, string correlationId, CancellationToken ct) { Context(tenantId,userId); return repository.AddQuoteItemAsync(tenantId,userId,id,request,correlationId,ct); }
    public Task<QuoteDto> ApplyQuoteDiscountAsync(Guid tenantId, Guid userId, Guid id, ApplyQuoteDiscountRequest request, string correlationId, CancellationToken ct) { Context(tenantId,userId); return repository.ApplyQuoteDiscountAsync(tenantId,userId,id,request,correlationId,ct); }
    public Task<QuoteDto> SubmitQuoteAsync(Guid tenantId, Guid userId, Guid id, QuoteDecisionRequest request, string correlationId, CancellationToken ct) { Context(tenantId,userId); return repository.SubmitQuoteAsync(tenantId,userId,id,request,correlationId,ct); }
    public Task<QuoteDto> DecideQuoteAsync(Guid tenantId, Guid userId, Guid id, bool approve, QuoteDecisionRequest request, string correlationId, CancellationToken ct) { Context(tenantId,userId); return repository.DecideQuoteAsync(tenantId,userId,id,approve,request,correlationId,ct); }
}
