using System.Security.Claims;
using IntegraRP.Application.Commercial;
using IntegraRP.Contracts.Commercial;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
public sealed class Operational360Controller(CommercialOperationsUseCases useCases) : ControllerBase
{
    private Guid TenantId => RequiredClaim("tenant_id");
    private Guid UserId => RequiredClaim(ClaimTypes.NameIdentifier, "sub");
    private string CorrelationId => HttpContext.TraceIdentifier;

    [Authorize(Policy="customers.view")][HttpGet("api/customers/{customerId:guid}/contacts")]
    public async Task<IActionResult> Contacts(Guid customerId,CancellationToken ct)=>Ok(await useCases.ListContactsAsync(TenantId,customerId,ct));
    [Authorize(Policy="customers.update")][HttpPost("api/customers/{customerId:guid}/contacts")]
    public async Task<IActionResult> AddContact(Guid customerId,SaveCustomerContactRequest request,CancellationToken ct)=>Created($"/api/customers/{customerId}/contacts",await useCases.AddContactAsync(TenantId,UserId,customerId,request,ct));
    [Authorize(Policy="customers.update")][HttpPut("api/customers/{customerId:guid}/contacts/{id:guid}")]
    public async Task<IActionResult> UpdateContact(Guid customerId,Guid id,SaveCustomerContactRequest request,CancellationToken ct)=>Ok(await useCases.UpdateContactAsync(TenantId,UserId,customerId,id,request,ct));
    [Authorize(Policy="customers.update")][HttpDelete("api/customers/{customerId:guid}/contacts/{id:guid}")]
    public async Task<IActionResult> DeleteContact(Guid customerId,Guid id,[FromQuery]long rowVersion,CancellationToken ct){await useCases.DeleteContactAsync(TenantId,UserId,customerId,id,rowVersion,ct);return NoContent();}
    [Authorize(Policy="customers.view")][HttpGet("api/customers/{customerId:guid}/addresses")]
    public async Task<IActionResult> Addresses(Guid customerId,CancellationToken ct)=>Ok(await useCases.ListAddressesAsync(TenantId,customerId,ct));
    [Authorize(Policy="customers.update")][HttpPost("api/customers/{customerId:guid}/addresses")]
    public async Task<IActionResult> AddAddress(Guid customerId,SaveCustomerAddressRequest request,CancellationToken ct)=>Created($"/api/customers/{customerId}/addresses",await useCases.AddAddressAsync(TenantId,UserId,customerId,request,ct));
    [Authorize(Policy="customers.update")][HttpPut("api/customers/{customerId:guid}/addresses/{id:guid}")]
    public async Task<IActionResult> UpdateAddress(Guid customerId,Guid id,SaveCustomerAddressRequest request,CancellationToken ct)=>Ok(await useCases.UpdateAddressAsync(TenantId,UserId,customerId,id,request,ct));
    [Authorize(Policy="customers.update")][HttpDelete("api/customers/{customerId:guid}/addresses/{id:guid}")]
    public async Task<IActionResult> DeleteAddress(Guid customerId,Guid id,[FromQuery]long rowVersion,CancellationToken ct){await useCases.DeleteAddressAsync(TenantId,UserId,customerId,id,rowVersion,ct);return NoContent();}

    [Authorize(Policy="opportunities.view")][HttpGet("api/opportunities")]
    public async Task<IActionResult> Opportunities(CancellationToken ct)=>Ok(await useCases.ListOpportunitiesAsync(TenantId,ct));
    [Authorize(Policy="opportunities.create")][HttpPost("api/opportunities")]
    public async Task<IActionResult> CreateOpportunity(CreateOpportunityRequest request,CancellationToken ct)=>Created("/api/opportunities",await useCases.CreateOpportunityAsync(TenantId,UserId,request,CorrelationId,ct));
    [Authorize(Policy="opportunities.update")][HttpPatch("api/opportunities/{id:guid}/stage")]
    public async Task<IActionResult> ChangeStage(Guid id,ChangeOpportunityStageRequest request,CancellationToken ct)=>Ok(await useCases.ChangeStageAsync(TenantId,UserId,id,request,CorrelationId,ct));

    [Authorize(Policy="quotes.view")][HttpGet("api/quotes")]
    public async Task<IActionResult> Quotes(CancellationToken ct)=>Ok(await useCases.ListQuotesAsync(TenantId,ct));
    [Authorize(Policy="quotes.view")][HttpGet("api/quotes/{id:guid}")]
    public async Task<IActionResult> Quote(Guid id,CancellationToken ct)=>Ok(await useCases.GetQuoteAsync(TenantId,id,ct));
    [Authorize(Policy="quotes.create")][HttpPost("api/quotes")]
    public async Task<IActionResult> CreateQuote(CreateQuoteRequest request,CancellationToken ct)=>Created("/api/quotes",await useCases.CreateQuoteAsync(TenantId,UserId,request,CorrelationId,ct));
    [Authorize(Policy="quotes.update")][HttpPost("api/quotes/{id:guid}/items")]
    public async Task<IActionResult> AddQuoteItem(Guid id,AddQuoteItemRequest request,CancellationToken ct)=>Ok(await useCases.AddQuoteItemAsync(TenantId,UserId,id,request,CorrelationId,ct));
    [Authorize(Policy="quotes.update")][HttpPatch("api/quotes/{id:guid}/discount")]
    public async Task<IActionResult> Discount(Guid id,ApplyQuoteDiscountRequest request,CancellationToken ct)=>Ok(await useCases.ApplyQuoteDiscountAsync(TenantId,UserId,id,request,CorrelationId,ct));
    [Authorize(Policy="quotes.submit")][HttpPost("api/quotes/{id:guid}/submit")]
    public async Task<IActionResult> Submit(Guid id,QuoteDecisionRequest request,CancellationToken ct)=>Ok(await useCases.SubmitQuoteAsync(TenantId,UserId,id,request,CorrelationId,ct));
    [Authorize(Policy="quote-approvals.decide")][HttpPost("api/quotes/{id:guid}/approve")]
    public async Task<IActionResult> Approve(Guid id,QuoteDecisionRequest request,CancellationToken ct)=>Ok(await useCases.DecideQuoteAsync(TenantId,UserId,id,true,request,CorrelationId,ct));
    [Authorize(Policy="quote-approvals.decide")][HttpPost("api/quotes/{id:guid}/reject")]
    public async Task<IActionResult> Reject(Guid id,QuoteDecisionRequest request,CancellationToken ct)=>Ok(await useCases.DecideQuoteAsync(TenantId,UserId,id,false,request,CorrelationId,ct));

    private Guid RequiredClaim(params string[] names)
    { foreach(var name in names) if(Guid.TryParse(User.FindFirst(name)?.Value,out var id)) return id; throw new UnauthorizedAccessException("Identidade autenticada inválida."); }
}
