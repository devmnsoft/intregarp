using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/customers")]
public sealed class CustomersController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [Authorize(Policy = "customers.view")]
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => ToAction(await useCases.ListCustomersAsync(TenantId, ct));
    [Authorize(Policy = "customers.view")]
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => ToAction(await useCases.GetCustomerAsync(TenantId, id, ct));
    [Authorize(Policy = "customers.create")]
    [HttpPost] public async Task<IActionResult> Create(DemoCustomerRequest request, CancellationToken ct) => ToAction(await useCases.CreateCustomerAsync(TenantId, request, ct));
    [Authorize(Policy = "customers.update")]
    [HttpPut("{id:guid}")] public async Task<IActionResult> Update(Guid id, DemoCustomerRequest request, CancellationToken ct) => ToAction(await useCases.UpdateCustomerAsync(TenantId, id, request, ct));
    [Authorize(Policy = "customers.delete")]
    [HttpDelete("{id:guid}")] public async Task<IActionResult> Delete(Guid id, CancellationToken ct) => ToAction(await useCases.DeleteCustomerAsync(TenantId, id, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
