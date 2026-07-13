namespace IntegraRP.Api.Security;

public sealed class SuperAdminTenantGuardMiddleware(RequestDelegate next)
{
    public async Task InvokeAsync(HttpContext context, ICurrentUserContext currentUser)
    {
        if (context.Request.Headers.TryGetValue("X-Tenant-Id", out var header) && !string.IsNullOrWhiteSpace(header))
        {
            if (!currentUser.IsSuperAdmin || !Guid.TryParse(header, out var requestedTenant) || requestedTenant == Guid.Empty)
            {
                context.Response.StatusCode = StatusCodes.Status403Forbidden;
                await context.Response.WriteAsJsonAsync(new { code = "tenant_header_forbidden", title = "Tenant não autorizado", correlation_id = context.TraceIdentifier });
                return;
            }
            context.Items["tenant_id"] = requestedTenant;
        }
        else
        {
            context.Items["tenant_id"] = currentUser.TenantId;
        }

        await next(context);
    }
}
