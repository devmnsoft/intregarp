namespace IntegraRP.Domain.Commercial;

public enum CustomerKind { Individual, Company, International }
public enum OpportunityStage { New, Qualification, Diagnosis, Proposal, Negotiation, Won, Lost, Cancelled }
public enum QuoteStatus { Draft, PendingApproval, Approved, Rejected, Sent, Accepted, Refused, Expired, Converted, Cancelled }
public enum OperationalTaskStatus { Pending, Assigned, InProgress, Paused, Completed, Cancelled }

public sealed record CustomerContact(Guid Id, string Name, string? Role, string? Email, string? Phone, bool WhatsApp, bool IsPrimary);
public sealed record CustomerAddress(Guid Id, string Type, string? PostalCode, string Street, string? Number, string? Complement,
    string? District, string City, string? State, bool Billing, bool Delivery, bool IsPrimary);

public sealed class Customer
{
    private readonly List<CustomerContact> _contacts = [];
    private readonly List<CustomerAddress> _addresses = [];
    private Customer(Guid id, Guid tenantId, CustomerKind kind, string name, string? document, string? email, string? phone, Guid actorId)
    {
        if (id == Guid.Empty || tenantId == Guid.Empty || actorId == Guid.Empty) throw new ArgumentException("Identificadores são obrigatórios.");
        Id = id; TenantId = tenantId; Kind = kind; Name = Required(name, "Nome"); Document = document?.Trim();
        Email = email?.Trim(); Phone = phone?.Trim(); Active = true; RowVersion = 1; UpdatedBy = actorId;
    }
    public Guid Id { get; }
    public Guid TenantId { get; }
    public CustomerKind Kind { get; }
    public string Name { get; private set; }
    public string? TradeName { get; private set; }
    public string? Document { get; private set; }
    public string? Email { get; private set; }
    public string? Phone { get; private set; }
    public Guid? CommercialOwnerId { get; private set; }
    public bool Active { get; private set; }
    public long RowVersion { get; private set; }
    public Guid UpdatedBy { get; private set; }
    public IReadOnlyList<CustomerContact> Contacts => _contacts;
    public IReadOnlyList<CustomerAddress> Addresses => _addresses;
    public static Customer Create(Guid tenantId, CustomerKind kind, string name, string? document, string? email, string? phone, Guid actorId)
        => new(Guid.NewGuid(), tenantId, kind, name, document, email, phone, actorId);
    public static Customer Rehydrate(Guid id, Guid tenantId, CustomerKind kind, string name, string? tradeName,
        string? document, string? email, string? phone, Guid? commercialOwnerId, bool active, long rowVersion,
        Guid updatedBy, IEnumerable<CustomerContact>? contacts = null, IEnumerable<CustomerAddress>? addresses = null)
    {
        if (rowVersion < 1) throw new ArgumentOutOfRangeException(nameof(rowVersion));
        var customer = new Customer(id, tenantId, kind, name, document, email, phone, updatedBy)
        {
            TradeName = tradeName?.Trim(), CommercialOwnerId = commercialOwnerId, Active = active, RowVersion = rowVersion
        };
        if (contacts is not null) customer._contacts.AddRange(contacts);
        if (addresses is not null) customer._addresses.AddRange(addresses);
        return customer;
    }
    public void ChangeName(string value, Guid actorId) { Name = Required(value, "Nome"); Touch(actorId); }
    public void ChangeTradeName(string? value, Guid actorId) { TradeName = value?.Trim(); Touch(actorId); }
    public void ChangeDocument(string? value, Guid actorId) { Document = value?.Trim(); Touch(actorId); }
    public void ChangeEmail(string? value, Guid actorId) { Email = value?.Trim(); Touch(actorId); }
    public void ChangePhone(string? value, Guid actorId) { Phone = value?.Trim(); Touch(actorId); }
    public void AssignCommercialOwner(Guid? ownerId, Guid actorId) { CommercialOwnerId = ownerId; Touch(actorId); }
    public CustomerContact AddContact(string name, string? role, string? email, string? phone, bool whatsApp, bool primary, Guid actorId)
    {
        var contact = new CustomerContact(Guid.NewGuid(), Required(name, "Nome do contato"), role?.Trim(), email?.Trim(), phone?.Trim(), whatsApp, primary);
        if (primary) ClearPrimaryContacts(); _contacts.Add(contact); Touch(actorId); return contact;
    }
    public void UpdateContact(Guid id, string name, string? role, string? email, string? phone, bool whatsApp, bool primary, Guid actorId)
    { var index = ContactIndex(id); if (primary) ClearPrimaryContacts(); _contacts[index] = new(id, Required(name, "Nome do contato"), role?.Trim(), email?.Trim(), phone?.Trim(), whatsApp, primary); Touch(actorId); }
    public void RemoveContact(Guid id, Guid actorId) { _contacts.RemoveAt(ContactIndex(id)); Touch(actorId); }
    public void SetPrimaryContact(Guid id, Guid actorId) { var index = ContactIndex(id); ClearPrimaryContacts(); _contacts[index] = _contacts[index] with { IsPrimary = true }; Touch(actorId); }
    public CustomerAddress AddAddress(string type, string? postalCode, string street, string? number, string? complement, string? district, string city, string? state, bool billing, bool delivery, bool primary, Guid actorId)
    { var value = new CustomerAddress(Guid.NewGuid(), Required(type, "Tipo"), postalCode?.Trim(), Required(street, "Logradouro"), number?.Trim(), complement?.Trim(), district?.Trim(), Required(city, "Cidade"), state?.Trim(), billing, delivery, primary); if (primary) ClearPrimaryAddresses(); _addresses.Add(value); Touch(actorId); return value; }
    public void UpdateAddress(CustomerAddress value, Guid actorId) { var index = AddressIndex(value.Id); if (value.IsPrimary) ClearPrimaryAddresses(); _addresses[index] = value; Touch(actorId); }
    public void RemoveAddress(Guid id, Guid actorId) { _addresses.RemoveAt(AddressIndex(id)); Touch(actorId); }
    public void SetPrimaryAddress(Guid id, Guid actorId) { var index = AddressIndex(id); ClearPrimaryAddresses(); _addresses[index] = _addresses[index] with { IsPrimary = true }; Touch(actorId); }
    public void Activate(Guid actorId) { Active = true; Touch(actorId); }
    public void Deactivate(Guid actorId) { Active = false; Touch(actorId); }
    private void ClearPrimaryContacts() { for (var i = 0; i < _contacts.Count; i++) _contacts[i] = _contacts[i] with { IsPrimary = false }; }
    private void ClearPrimaryAddresses() { for (var i = 0; i < _addresses.Count; i++) _addresses[i] = _addresses[i] with { IsPrimary = false }; }
    private int ContactIndex(Guid id) { var index = _contacts.FindIndex(x => x.Id == id); return index >= 0 ? index : throw new KeyNotFoundException("Contato não encontrado."); }
    private int AddressIndex(Guid id) { var index = _addresses.FindIndex(x => x.Id == id); return index >= 0 ? index : throw new KeyNotFoundException("Endereço não encontrado."); }
    private void Touch(Guid actorId) { if (actorId == Guid.Empty) throw new ArgumentException("Usuário é obrigatório."); UpdatedBy = actorId; RowVersion++; }
    private static string Required(string value, string field) => string.IsNullOrWhiteSpace(value) ? throw new ArgumentException($"{field} é obrigatório.") : value.Trim();
}

public sealed class CommercialOpportunity
{
    private CommercialOpportunity(Guid tenantId, Guid customerId, string name, Guid ownerId, decimal expectedValue, DateOnly expectedCloseDate)
    { if (tenantId == Guid.Empty || customerId == Guid.Empty || ownerId == Guid.Empty) throw new ArgumentException("Tenant, cliente e responsável são obrigatórios."); Id = Guid.NewGuid(); TenantId = tenantId; CustomerId = customerId; Name = Required(name); OwnerId = ownerId; ExpectedValue = expectedValue >= 0 ? expectedValue : throw new ArgumentOutOfRangeException(nameof(expectedValue)); ExpectedCloseDate = expectedCloseDate; Stage = OpportunityStage.New; Probability = 10; RowVersion = 1; }
    public Guid Id { get; private set; } public Guid TenantId { get; } public Guid CustomerId { get; } public string Name { get; private set; }
    public Guid OwnerId { get; private set; } public OpportunityStage Stage { get; private set; } public int Probability { get; private set; }
    public decimal ExpectedValue { get; private set; } public DateOnly ExpectedCloseDate { get; private set; } public string? NextAction { get; private set; }
    public DateTimeOffset? NextActionAt { get; private set; } public string? LossReason { get; private set; } public long RowVersion { get; private set; }
    public static CommercialOpportunity Create(Guid tenantId, Guid customerId, string name, Guid ownerId, decimal value, DateOnly closeDate) => new(tenantId, customerId, name, ownerId, value, closeDate);
    public static CommercialOpportunity Rehydrate(Guid id, Guid tenantId, Guid customerId, string name, Guid ownerId,
        OpportunityStage stage, int probability, decimal expectedValue, DateOnly expectedCloseDate, string? nextAction,
        DateTimeOffset? nextActionAt, string? lossReason, long rowVersion)
    {
        if (id == Guid.Empty || rowVersion < 1) throw new ArgumentException("Identificador e versão persistida são obrigatórios.");
        if (probability is < 0 or > 100) throw new ArgumentOutOfRangeException(nameof(probability));
        var opportunity = new CommercialOpportunity(tenantId, customerId, name, ownerId, expectedValue, expectedCloseDate)
        { Id = id, Stage = stage, Probability = probability, NextAction = nextAction, NextActionAt = nextActionAt,
          LossReason = lossReason, RowVersion = rowVersion };
        return opportunity;
    }
    public void Rename(string value) { EnsureOpen(); Name = Required(value); Touch(); }
    public void AssignOwner(Guid ownerId) { EnsureOpen(); OwnerId = ownerId != Guid.Empty ? ownerId : throw new ArgumentException("Responsável obrigatório."); Touch(); }
    public void ChangeStage(OpportunityStage stage) { EnsureOpen(); Stage = stage; Touch(); }
    public void ChangeProbability(int value) { EnsureOpen(); Probability = value is >= 0 and <= 100 ? value : throw new ArgumentOutOfRangeException(nameof(value)); Touch(); }
    public void ChangeExpectedValue(decimal value) { EnsureOpen(); ExpectedValue = value >= 0 ? value : throw new ArgumentOutOfRangeException(nameof(value)); Touch(); }
    public void SetExpectedCloseDate(DateOnly value) { EnsureOpen(); ExpectedCloseDate = value; Touch(); }
    public void SetNextAction(string action, DateTimeOffset dueAt) { EnsureOpen(); NextAction = Required(action); NextActionAt = dueAt; Touch(); }
    public void MarkAsWon() { EnsureOpen(); Stage = OpportunityStage.Won; Probability = 100; Touch(); }
    public void MarkAsLost(string reason) { EnsureOpen(); LossReason = Required(reason); Stage = OpportunityStage.Lost; Probability = 0; Touch(); }
    public void Cancel() { EnsureOpen(); Stage = OpportunityStage.Cancelled; Touch(); }
    private void EnsureOpen() { if (Stage is OpportunityStage.Won or OpportunityStage.Lost or OpportunityStage.Cancelled) throw new InvalidOperationException("Oportunidade encerrada é imutável."); }
    private void Touch() => RowVersion++;
    private static string Required(string value) => string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Valor obrigatório.") : value.Trim();
}

public sealed record SalesQuoteItem(Guid Id, Guid ProductId, string Description, decimal Quantity, decimal UnitPrice, decimal DiscountPercent)
{ public decimal Subtotal => decimal.Round(Quantity * UnitPrice, 2); public decimal Discount => decimal.Round(Subtotal * DiscountPercent / 100m, 2); public decimal Total => Math.Max(0, Subtotal - Discount); }

public sealed class SalesQuote
{
    private readonly List<SalesQuoteItem> _items = [];
    private SalesQuote(Guid tenantId, Guid customerId, string number, DateOnly validity) { if (tenantId == Guid.Empty || customerId == Guid.Empty) throw new ArgumentException("Tenant e cliente obrigatórios."); Id = Guid.NewGuid(); TenantId = tenantId; CustomerId = customerId; Number = Required(number); ChangeValidity(validity); Status = QuoteStatus.Draft; RowVersion = 1; }
    public Guid Id { get; private set; } public Guid TenantId { get; } public Guid CustomerId { get; private set; } public string Number { get; }
    public DateOnly Validity { get; private set; } public QuoteStatus Status { get; private set; } public decimal GlobalDiscountPercent { get; private set; }
    public decimal Subtotal { get; private set; } public decimal Discount { get; private set; } public decimal Total { get; private set; }
    public Guid? ApprovedBy { get; private set; } public DateTimeOffset? ApprovedAt { get; private set; } public string? RejectionReason { get; private set; }
    public long RowVersion { get; private set; } public IReadOnlyList<SalesQuoteItem> Items => _items;
    public static SalesQuote CreateDraft(Guid tenantId, Guid customerId, string number, DateOnly validity) => new(tenantId, customerId, number, validity);
    public static SalesQuote Rehydrate(Guid id, Guid tenantId, Guid customerId, string number, DateOnly validity,
        QuoteStatus status, decimal globalDiscountPercent, Guid? approvedBy, DateTimeOffset? approvedAt,
        string? rejectionReason, long rowVersion, IEnumerable<SalesQuoteItem>? items = null)
    {
        if (id == Guid.Empty || rowVersion < 1) throw new ArgumentException("Identificador e versão persistida são obrigatórios.");
        ValidateDiscount(globalDiscountPercent);
        var quote = new SalesQuote(tenantId, customerId, number, validity)
        { Id = id, Status = status, GlobalDiscountPercent = globalDiscountPercent, ApprovedBy = approvedBy,
          ApprovedAt = approvedAt, RejectionReason = rejectionReason };
        if (items is not null) quote._items.AddRange(items);
        quote.Recalculate();
        quote.RowVersion = rowVersion;
        return quote;
    }
    public void ChangeCustomer(Guid id) { EnsureDraft(); CustomerId = id != Guid.Empty ? id : throw new ArgumentException("Cliente obrigatório."); Touch(); }
    public void ChangeValidity(DateOnly value) { EnsureMutable(); if (value < DateOnly.FromDateTime(DateTime.UtcNow)) throw new ArgumentException("Validade não pode estar no passado."); Validity = value; Touch(); }
    public SalesQuoteItem AddItem(Guid productId, string description, decimal quantity, decimal serverPrice) { EnsureDraft(); ValidateLine(productId, quantity, serverPrice, 0); var item = new SalesQuoteItem(Guid.NewGuid(), productId, Required(description), quantity, serverPrice, 0); _items.Add(item); Recalculate(); return item; }
    public void UpdateItem(Guid id, decimal quantity, decimal serverPrice) { EnsureDraft(); var i = ItemIndex(id); ValidateLine(_items[i].ProductId, quantity, serverPrice, _items[i].DiscountPercent); _items[i] = _items[i] with { Quantity = quantity, UnitPrice = serverPrice }; Recalculate(); }
    public void RemoveItem(Guid id) { EnsureDraft(); _items.RemoveAt(ItemIndex(id)); Recalculate(); }
    public void ApplyItemDiscount(Guid id, decimal percent) { EnsureDraft(); ValidateDiscount(percent); var i = ItemIndex(id); _items[i] = _items[i] with { DiscountPercent = percent }; Recalculate(); }
    public void ApplyGlobalDiscount(decimal percent) { EnsureDraft(); ValidateDiscount(percent); GlobalDiscountPercent = percent; Recalculate(); }
    public void Recalculate() { Subtotal = _items.Sum(x => x.Subtotal); var itemDiscount = _items.Sum(x => x.Discount); var afterItems = Subtotal - itemDiscount; Discount = itemDiscount + decimal.Round(afterItems * GlobalDiscountPercent / 100m, 2); Total = Math.Max(0, Subtotal - Discount); Touch(); }
    public void SubmitForApproval() { EnsureDraft(); if (_items.Count == 0) throw new InvalidOperationException("Orçamento sem itens."); Status = QuoteStatus.PendingApproval; Touch(); }
    public void Approve(Guid userId, DateTimeOffset now) { RequireStatus(QuoteStatus.PendingApproval); ApprovedBy = userId != Guid.Empty ? userId : throw new ArgumentException("Aprovador obrigatório."); ApprovedAt = now; Status = QuoteStatus.Approved; Touch(); }
    public void Reject(Guid userId, string reason) { RequireStatus(QuoteStatus.PendingApproval); if (userId == Guid.Empty) throw new ArgumentException("Aprovador obrigatório."); RejectionReason = Required(reason); Status = QuoteStatus.Rejected; Touch(); }
    public void MarkAsSent() { RequireStatus(QuoteStatus.Approved); Status = QuoteStatus.Sent; Touch(); }
    public void Accept(DateOnly today) { if (today > Validity) { Status = QuoteStatus.Expired; Touch(); throw new InvalidOperationException("Orçamento vencido não pode ser aceito."); } if (Status is not (QuoteStatus.Approved or QuoteStatus.Sent)) throw new InvalidOperationException("Estado inválido."); Status = QuoteStatus.Accepted; Touch(); }
    public void Refuse() { if (Status is not (QuoteStatus.Approved or QuoteStatus.Sent)) throw new InvalidOperationException("Estado inválido."); Status = QuoteStatus.Refused; Touch(); }
    public void Expire(DateOnly today) { EnsureMutable(); if (today <= Validity) throw new InvalidOperationException("Orçamento ainda válido."); Status = QuoteStatus.Expired; Touch(); }
    public void ConvertToOrder() { if (Status is not (QuoteStatus.Approved or QuoteStatus.Accepted)) throw new InvalidOperationException("Somente orçamento aprovado pode ser convertido."); Status = QuoteStatus.Converted; Touch(); }
    public void Cancel() { EnsureMutable(); Status = QuoteStatus.Cancelled; Touch(); }
    private void EnsureDraft() { if (Status != QuoteStatus.Draft) throw new InvalidOperationException("Somente rascunho pode ser alterado."); }
    private void EnsureMutable() { if (Status is QuoteStatus.Converted or QuoteStatus.Cancelled) throw new InvalidOperationException("Orçamento encerrado é imutável."); }
    private void RequireStatus(QuoteStatus value) { if (Status != value) throw new InvalidOperationException("Estado inválido."); }
    private int ItemIndex(Guid id) { var i = _items.FindIndex(x => x.Id == id); return i >= 0 ? i : throw new KeyNotFoundException("Item não encontrado."); }
    private static void ValidateLine(Guid id, decimal quantity, decimal price, decimal discount) { if (id == Guid.Empty || quantity <= 0 || price < 0) throw new ArgumentException("Produto, quantidade e preço válidos são obrigatórios."); ValidateDiscount(discount); }
    private static void ValidateDiscount(decimal value) { if (value is < 0 or > 100) throw new ArgumentOutOfRangeException(nameof(value)); }
    private static string Required(string value) => string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Valor obrigatório.") : value.Trim();
    private void Touch() => RowVersion++;
}
