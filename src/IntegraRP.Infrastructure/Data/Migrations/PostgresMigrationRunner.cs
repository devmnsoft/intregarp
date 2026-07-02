using System.Diagnostics;
using Dapper;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Data.Migrations;

public sealed class PostgresMigrationRunner(
    IDbConnectionFactory factory,
    IConfiguration configuration,
    ILogger<PostgresMigrationRunner> logger) : IMigrationRunner
{
    private const long LockKey = 2026070201;

    public async Task RunAsync(CancellationToken ct)
    {
        try
        {
            var directory = ResolveMigrationsPath();
            logger.LogInformation("Iniciando migrations IntegraRP em {Directory}", directory);

            if (!Directory.Exists(directory))
            {
                logger.LogWarning("Diretório de migrations não encontrado: {Directory}", directory);
                return;
            }

            using var connection = await factory.OpenConnectionAsync(ct);
            await EnsureHistoryTableAsync(connection);
            await connection.ExecuteAsync("SELECT pg_advisory_lock(@LockKey)", new { LockKey });

            try
            {
                foreach (var file in Directory.GetFiles(directory, "*.sql").OrderBy(Path.GetFileName))
                {
                    var script = new MigrationScript(Path.GetFileName(file), file, await File.ReadAllTextAsync(file, ct));
                    var history = new MigrationHistoryRepository(connection);
                    var existingChecksum = await history.GetChecksumAsync(script.Name);

                    if (existingChecksum == script.ChecksumSha256)
                    {
                        logger.LogInformation("Migration {ScriptName} ignorada: checksum já aplicado", script.Name);
                        continue;
                    }

                    if (existingChecksum is not null)
                    {
                        throw new InvalidOperationException($"Migration {script.Name} já executada com checksum diferente.");
                    }

                    await ExecuteScriptAsync(connection, script, ct);
                }
            }
            finally
            {
                await connection.ExecuteAsync("SELECT pg_advisory_unlock(@LockKey)", new { LockKey });
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha no migration runner IntegraRP");
            throw;
        }
    }

    private async Task ExecuteScriptAsync(System.Data.IDbConnection connection, MigrationScript script, CancellationToken cancellationToken)
    {
        var stopwatch = Stopwatch.StartNew();
        using var transaction = connection.BeginTransaction();
        var history = new MigrationHistoryRepository(connection, transaction);

        try
        {
            logger.LogInformation("Aplicando migration {ScriptName}", script.Name);
            await connection.ExecuteAsync(script.Sql, transaction: transaction);
            await history.RegisterSuccessAsync(script, stopwatch.ElapsedMilliseconds, Environment.UserName);
            transaction.Commit();
            logger.LogInformation("Migration {ScriptName} aplicada em {Duration} ms", script.Name, stopwatch.ElapsedMilliseconds);
        }
        catch (Exception ex)
        {
            transaction.Rollback();
            logger.LogError(ex, "Erro aplicando migration {ScriptName}", script.Name);
            throw;
        }
    }

    private string ResolveMigrationsPath()
    {
        var configured = configuration["IntegraRP:Database:MigrationsPath"];
        if (!string.IsNullOrWhiteSpace(configured) && Directory.Exists(configured)) return configured;

        var current = new DirectoryInfo(AppContext.BaseDirectory);
        while (current is not null)
        {
            var candidate = Path.Combine(current.FullName, "database", "migrations");
            if (Directory.Exists(candidate)) return candidate;
            current = current.Parent;
        }

        return Path.Combine(Directory.GetCurrentDirectory(), "database", "migrations");
    }

    private static Task EnsureHistoryTableAsync(System.Data.IDbConnection connection) => connection.ExecuteAsync(
        """
        CREATE EXTENSION IF NOT EXISTS pgcrypto;
        CREATE SCHEMA IF NOT EXISTS integrarp;
        CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (
          migration_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
          script_name varchar(260) UNIQUE NOT NULL,
          checksum_sha256 varchar(128) NOT NULL,
          executed_at timestamptz NOT NULL DEFAULT now(),
          duration_ms bigint NOT NULL DEFAULT 0,
          success boolean NOT NULL,
          error_message text NULL,
          executed_by varchar(160) NULL
        );
        """);
}
