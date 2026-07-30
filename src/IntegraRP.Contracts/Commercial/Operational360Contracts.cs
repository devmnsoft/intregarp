namespace IntegraRP.Contracts.Commercial;

public sealed record CustomerContactDto(Guid Id, string Name, string? Role, string? Email, string? Phone, bool WhatsApp, bool Primary, long RowVersion);
public sealed record SaveCustomerContactRequest(string Name, string? Role, string? Email, string? Phone, bool WhatsApp, bool Primary, long? RowVersion);
public sealed record CustomerAddressDto(Guid Id, string Type, string? PostalCode, string Street, string? Number, string? Complement, string? District, string City, string? State, bool Billing, bool Delivery, bool Primary, long RowVersion);
public sealed record SaveCustomerAddressRequest(string Type, string? PostalCode, string Street, string? Number, string? Complement, string? District, string City, string? State, bool Billing, bool Delivery, bool Primary, long? RowVersion);
public sealed record OpportunityDto(Guid Id, Guid CustomerId, string CustomerName, string Name, string Stage, int Probability, decimal ExpectedValue, DateOnly ExpectedCloseDate, string? NextAction, DateTimeOffset? NextActionAt, Guid OwnerId, long RowVersion);
public sealed record CreateOpportunityRequest(Guid CustomerId, string Name, decimal ExpectedValue, DateOnly ExpectedCloseDate, string? NextAction, DateTimeOffset? NextActionAt);
public sealed record ChangeOpportunityStageRequest(string Stage, long RowVersion);
public sealed record QuoteItemDto(Guid Id, Guid ProductId, string Sku, string Description, decimal Quantity, decimal UnitPrice, decimal DiscountPercent, decimal Subtotal, decimal Discount, decimal Total);
public sealed record QuoteDto(Guid Id, string Number, Guid CustomerId, string CustomerName, DateOnly Validity, string Status, decimal GlobalDiscountPercent, decimal Subtotal, decimal Discount, decimal Total, long RowVersion, IReadOnlyList<QuoteItemDto> Items);
public sealed record CreateQuoteRequest(Guid CustomerId, Guid? OpportunityId, Guid? PriceListId, DateOnly Validity, string IdempotencyKey);
public sealed record AddQuoteItemRequest(Guid ProductId, decimal Quantity, decimal DiscountPercent, long RowVersion);
public sealed record ApplyQuoteDiscountRequest(decimal DiscountPercent, long RowVersion);
public sealed record QuoteDecisionRequest(long RowVersion, string? Reason);

