using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/products")]
public sealed class ProductsController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [Authorize(Policy = "products.view")]
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => ToAction(await useCases.ListProductsAsync(TenantId, ct));
    [Authorize(Policy = "products.view")]
    [HttpGet("{id:guid}")] public async Task<IActionResult> Get(Guid id, CancellationToken ct) => ToAction(await useCases.GetProductAsync(TenantId, id, ct));
    [Authorize(Policy = "products.manage")]
    [HttpPost] public async Task<IActionResult> Create(DemoProductRequest request, CancellationToken ct) => ToAction(await useCases.CreateProductAsync(TenantId, request, ct));
    [Authorize(Policy = "products.manage")]
    [HttpPut("{id:guid}")] public async Task<IActionResult> Update(Guid id, DemoProductRequest request, CancellationToken ct) => ToAction(await useCases.UpdateProductAsync(TenantId, id, request, ct));
    [Authorize(Policy = "products.manage")]
    [HttpDelete("{id:guid}")] public async Task<IActionResult> Delete(Guid id, CancellationToken ct) => ToAction(await useCases.DeleteProductAsync(TenantId, id, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
