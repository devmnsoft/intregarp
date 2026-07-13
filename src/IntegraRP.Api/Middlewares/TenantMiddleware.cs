namespace IntegraRP.Api.Middlewares;

[Obsolete("Tenant resolution now comes from JWT claims via SuperAdminTenantGuardMiddleware.")]
public sealed class TenantMiddleware(RequestDelegate next)
{
    public Task InvokeAsync(HttpContext context) => next(context);
}
