using Microsoft.Extensions.Diagnostics.HealthChecks;
using Npgsql;

namespace IntegraRP.Api.Health;

public sealed class PostgreSqlConnectionHealthCheck(IConfiguration configuration) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        try
        {
            await using var connection = new NpgsqlConnection(configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync(cancellationToken);
            await using var command = new NpgsqlCommand("select 1", connection);
            await command.ExecuteScalarAsync(cancellationToken);
            return HealthCheckResult.Healthy("PostgreSQL acessível.");
        }
        catch (Exception ex) { return HealthCheckResult.Unhealthy("PostgreSQL indisponível.", ex); }
    }
}

public sealed class IntegraRpSchemaHealthCheck(IConfiguration configuration) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        try
        {
            await using var connection = new NpgsqlConnection(configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync(cancellationToken);
            const string sql = "select exists(select 1 from information_schema.schemata where schema_name = 'integrarp') and exists(select 1 from information_schema.tables where table_schema = 'integrarp' and table_name = 'schema_migrations') and exists(select 1 from integrarp.schema_migrations where version = '0030')";
            await using var command = new NpgsqlCommand(sql, connection);
            var ready = (bool?)await command.ExecuteScalarAsync(cancellationToken) == true;
            return ready ? HealthCheckResult.Healthy("Schema integrarp v1.24 aplicado.") : HealthCheckResult.Unhealthy("Schema integrarp ou migration 0030 ausente.");
        }
        catch (Exception ex) { return HealthCheckResult.Unhealthy("Falha ao validar schema integrarp.", ex); }
    }
}

public sealed class LocalStorageHealthCheck(IWebHostEnvironment environment) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        try
        {
            var directory = Path.Combine(environment.ContentRootPath, "App_Data", "health");
            Directory.CreateDirectory(directory);
            var file = Path.Combine(directory, $"health-{Guid.NewGuid():N}.tmp");
            await File.WriteAllTextAsync(file, "ok", cancellationToken);
            File.Delete(file);
            return HealthCheckResult.Healthy("Storage local gravável.");
        }
        catch (Exception ex) { return HealthCheckResult.Unhealthy("Storage local indisponível.", ex); }
    }
}
