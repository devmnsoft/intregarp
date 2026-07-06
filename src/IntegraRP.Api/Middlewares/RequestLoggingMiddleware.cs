using System.Diagnostics;

namespace IntegraRP.Api.Middlewares;

public sealed class RequestLoggingMiddleware(RequestDelegate next, ILogger<RequestLoggingMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        var stopwatch = Stopwatch.StartNew();
        var tenantId = context.Items.TryGetValue("tenant_id", out var tenant) ? tenant?.ToString() : null;
        var userId = context.User?.Identity?.IsAuthenticated == true ? context.User.Identity.Name : null;

        using (logger.BeginScope(new Dictionary<string, object?>
        {
            ["correlation_id"] = context.TraceIdentifier,
            ["tenant_id"] = tenantId,
            ["usuario_id"] = userId
        }))
        {
            try
            {
                await next(context);
            }
            finally
            {
                stopwatch.Stop();
                logger.LogInformation(
                    "HTTP {Method} {Path} respondeu {StatusCode} em {ElapsedMilliseconds}ms",
                    context.Request.Method,
                    context.Request.Path,
                    context.Response.StatusCode,
                    stopwatch.ElapsedMilliseconds);
            }
        }
    }
}
