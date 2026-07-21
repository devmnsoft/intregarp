using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Controllers;

[ApiController]
[Route("api")]
public sealed class ApiProxyController(IHttpClientFactory httpClientFactory, ILogger<ApiProxyController> logger) : ControllerBase
{
    private static readonly string[] AllowedPrefixes =
    [
        "/api/activities",
        "/api/dashboard",
        "/api/dynamic/",
        "/api/flow/designer/",
        "/api/journey/",
        "/api/studio/"
    ];

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

    [Route("proxy")]
    public Task<IActionResult> GenericProxy([FromQuery] string path, CancellationToken cancellationToken)
    {
        if (!IsAllowed(path))
        {
            return Task.FromResult<IActionResult>(Problem(
                title: "Rota de proxy não permitida",
                detail: "O BFF aceita apenas rotas internas em allowlist para evitar proxy aberto/SSRF.",
                statusCode: StatusCodes.Status403Forbidden));
        }

        return Proxy(path, cancellationToken);
    }

    private static bool IsAllowed(string? path)
    {
        if (string.IsNullOrWhiteSpace(path) || !path.StartsWith('/')) return false;
        if (Uri.TryCreate(path, UriKind.Absolute, out _)) return false;
        if (path.Contains("..", StringComparison.Ordinal)) return false;
        return AllowedPrefixes.Any(prefix => path.StartsWith(prefix, StringComparison.OrdinalIgnoreCase));
    }

    private async Task<IActionResult> Proxy(string path, CancellationToken cancellationToken)
    {
        try
        {
            var client = httpClientFactory.CreateClient("IntegraRP.Api");
            var target = path + Request.QueryString;
            using var request = new HttpRequestMessage(new HttpMethod(Request.Method), target);

            ForwardHeader("Authorization", request.Headers.TryAddWithoutValidation);
            ForwardHeader("X-Correlation-Id", request.Headers.TryAddWithoutValidation);
            ForwardHeader("X-Tenant-Id", request.Headers.TryAddWithoutValidation);

            if (Request.ContentLength > 0)
            {
                request.Content = new StreamContent(Request.Body);
                request.Content.Headers.ContentType = MediaTypeHeaderValue.Parse(Request.ContentType ?? "application/json");
            }

            var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
            var body = await response.Content.ReadAsStringAsync(cancellationToken);
            var contentType = response.Content.Headers.ContentType?.ToString() ?? "application/json";
            return new ContentResult { StatusCode = (int)response.StatusCode, Content = body, ContentType = contentType };
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha consumindo API em {Path}", path);
            return StatusCode(StatusCodes.Status503ServiceUnavailable, new { erro = "API indisponível", correlation_id = HttpContext.TraceIdentifier });
        }
    }

    private void ForwardHeader(string name, Func<string, IEnumerable<string>, bool> add)
    {
        if (Request.Headers.TryGetValue(name, out var values))
        {
            add(name, values.ToArray());
        }
    }
}
