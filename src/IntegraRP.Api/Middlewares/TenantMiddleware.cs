namespace IntegraRP.Api.Middlewares;

public sealed class TenantMiddleware(RequestDelegate next, ILogger<TenantMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        context.Items["tenant_id"] = context.Request.Headers.TryGetValue("X-Tenant-Id", out var tenant) ? tenant.ToString() : "demo";
        logger.LogDebug("Tenant resolvido: {TenantId}", context.Items["tenant_id"]);
        await next(context);
    }
}
