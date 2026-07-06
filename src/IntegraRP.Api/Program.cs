using IntegraRP.Api.Extensions;
using IntegraRP.Api.Middlewares;
using IntegraRP.Application;
using IntegraRP.Infrastructure.Data.Migrations;
using IntegraRP.Infrastructure.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);
builder.Services.AddApiServices(builder.Configuration);

var app = builder.Build();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<TenantMiddleware>();
app.UseMiddleware<RequestLoggingMiddleware>();
app.UseMiddleware<GlobalExceptionMiddleware>();

app.UseSwagger();
app.UseSwaggerUI();

if (app.Configuration.GetValue<bool>("IntegraRP:RunMigrations") && !app.Environment.IsProduction())
{
    using var scope = app.Services.CreateScope();
    await scope.ServiceProvider.GetRequiredService<IMigrationRunner>().RunAsync(CancellationToken.None);
}

app.UseCors(policy => policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
app.MapControllers();
app.MapHealthChecks("/health");
app.MapHealthChecks("/api/health/live");
app.MapHealthChecks("/api/health/ready");
app.Run();
