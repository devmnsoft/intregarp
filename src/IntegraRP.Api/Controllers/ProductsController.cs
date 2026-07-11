using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/products")]
public sealed class ProductsController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => ToAction(await useCases.ListProductsAsync(TenantId, ct));
    [HttpGet("{id:guid}")] public IActionResult Get(Guid id) => Problem("Consulta por id será consolidada no repository dedicado.", statusCode: 501);
    [HttpPost] public async Task<IActionResult> Create(DemoProductRequest request, CancellationToken ct) => ToAction(await useCases.CreateProductAsync(TenantId, request, ct));
    [HttpPut("{id:guid}")] public async Task<IActionResult> Update(Guid id, DemoProductRequest request, CancellationToken ct) => ToAction(await useCases.UpdateProductAsync(TenantId, id, request, ct));
    [HttpDelete("{id:guid}")] public IActionResult Delete(Guid id) => Problem("Soft delete dedicado será concluído no CRUD completo.", statusCode: 501);
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
