using IntegraRP.Api.Extensions;
using IntegraRP.Api.Middlewares;
using IntegraRP.Api.Security;
using IntegraRP.Application;
using IntegraRP.Infrastructure.Data.Migrations;
using IntegraRP.Infrastructure.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);
builder.Services.AddApiServices(builder.Configuration);

var app = builder.Build();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseAuthentication();
app.UseMiddleware<SuperAdminTenantGuardMiddleware>();
app.UseAuthorization();
app.UseMiddleware<RequestLoggingMiddleware>();
app.UseMiddleware<GlobalExceptionMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

if (app.Configuration.GetValue<bool>("IntegraRP:RunMigrations") && !app.Environment.IsProduction())
{
    using var scope = app.Services.CreateScope();
    await scope.ServiceProvider.GetRequiredService<IMigrationRunner>().RunAsync(CancellationToken.None);
}

var allowedOrigins = app.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
app.UseCors(policy =>
{
    policy.AllowAnyHeader().AllowAnyMethod();
    if (app.Environment.IsProduction())
    {
        if (allowedOrigins.Length == 0)
        {
            throw new InvalidOperationException("Cors:AllowedOrigins deve ser configurado em Production.");
        }

        policy.WithOrigins(allowedOrigins);
    }
    else
    {
        policy.SetIsOriginAllowed(_ => true);
    }
});
app.MapControllers();
app.MapHealthChecks("/health");
app.MapHealthChecks("/api/health/live");
app.MapHealthChecks("/api/health/ready");
app.Run();
