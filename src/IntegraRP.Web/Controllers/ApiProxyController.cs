using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

[ApiController]
[Route("api")]
public sealed class ApiProxyController(IHttpClientFactory httpClientFactory, ILogger<ApiProxyController> logger) : ControllerBase
{
    [HttpGet("dashboard/resumo")]
    public Task<IActionResult> Dashboard(CancellationToken cancellationToken) => Proxy("/api/dashboard/resumo", cancellationToken);

    [HttpGet("tarefas")]
    public Task<IActionResult> Tarefas(CancellationToken cancellationToken) => Proxy("/api/tarefas", cancellationToken);

    [HttpGet("project/boards")]
    public Task<IActionResult> Boards(CancellationToken cancellationToken) => Proxy("/api/project/boards", cancellationToken);

    [HttpGet("processos/templates")]
    public Task<IActionResult> Processos(CancellationToken cancellationToken) => Proxy("/api/processos/templates", cancellationToken);

    [HttpGet("setores")]
    public Task<IActionResult> Setores(CancellationToken cancellationToken) => Proxy("/api/setores", cancellationToken);

    [HttpGet("usuarios")]
    public Task<IActionResult> Usuarios(CancellationToken cancellationToken) => Proxy("/api/usuarios", cancellationToken);

    [HttpGet("catalogo/modulos")]
    public Task<IActionResult> Modulos(CancellationToken cancellationToken) => Proxy("/api/catalogo/modulos", cancellationToken);

    [Route("flow/designer/{**path}")]
    public Task<IActionResult> FlowDesignerProxy(string path, CancellationToken cancellationToken) => Proxy($"/api/flow/designer/{path}", cancellationToken);

    private async Task<IActionResult> Proxy(string path, CancellationToken cancellationToken)
    {
        try
        {
            var client = httpClientFactory.CreateClient("IntegraRP.Api");
            using var request = new HttpRequestMessage(new HttpMethod(Request.Method), path + Request.QueryString);
            if (Request.ContentLength > 0)
            {
                request.Content = new StreamContent(Request.Body);
                request.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(Request.ContentType ?? "application/json");
            }
            var response = await client.SendAsync(request, cancellationToken);
            var json = await response.Content.ReadAsStringAsync(cancellationToken);
            return StatusCode((int)response.StatusCode, json);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha consumindo API em {Path}", path);
            return StatusCode(503, new { erro = "API indisponível", path });
        }
    }
}
