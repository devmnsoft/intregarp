using IntegraRP.Application.Runtime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/orders")]
public sealed class OrdersController(OperationalRuntimeUseCases useCases) : IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List(CancellationToken ct) => ToAction(await useCases.ListOrdersAsync(TenantId, ct));
    [HttpGet("{id:guid}")] public IActionResult Get(Guid id) => Problem("Consulta por id será consolidada no repository dedicado.", statusCode: 501);
    [HttpPost] public IActionResult Create() => Problem("Criação completa será consolidada no use case dedicado.", statusCode: 501);
    [HttpPost("{id:guid}/items")] public IActionResult AddItem(Guid id) => Problem("Itens serão consolidados no use case dedicado.", statusCode: 501);
    [HttpDelete("{id:guid}/items/{itemId:guid}")] public IActionResult RemoveItem(Guid id, Guid itemId) => Problem("Itens serão consolidados no use case dedicado.", statusCode: 501);
    [HttpPost("{id:guid}/confirm")] public async Task<IActionResult> Confirm(Guid id, CancellationToken ct) => ToAction(await useCases.ConfirmOrderAsync(TenantId, id, ct));
    [HttpPost("{id:guid}/cancel")] public IActionResult Cancel(Guid id) => Problem("Cancelamento será consolidado no use case dedicado.", statusCode: 501);
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(result.Error, statusCode: 400);
}
