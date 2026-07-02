namespace IntegraRP.Api.Middlewares;

public sealed class CorrelationIdMiddleware(RequestDelegate next, ILogger<CorrelationIdMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        var correlationId = context.Request.Headers.TryGetValue("X-Correlation-Id", out var header) ? header.ToString() : Guid.NewGuid().ToString("N");
        context.TraceIdentifier = correlationId;
        context.Response.Headers["X-Correlation-Id"] = correlationId;

        using (logger.BeginScope(new Dictionary<string, object> { ["correlation_id"] = correlationId }))
        {
            await next(context);
        }
    }
}
