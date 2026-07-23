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

    private static readonly MigrationCompatibilityPlan CompatibilityPlan = MigrationCompatibilityPlan.V127();

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
                var historicalMigrationsToValidate = new List<KnownHistoricalMigration>();

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
                        var knownHistorical = CompatibilityPlan.Find(script.Name, existingChecksum);
                        if (knownHistorical is not null)
                        {
                            logger.LogWarning("Migration {ScriptName} já executada com checksum histórico conhecido {Checksum}; preservando histórico, não reaplicando script corrigido e aguardando migration corretiva {CorrectiveMigration}", script.Name, existingChecksum, knownHistorical.CorrectiveMigration);
                            historicalMigrationsToValidate.Add(knownHistorical);
                            continue;
                        }

                        throw new InvalidOperationException($"Migration {script.Name} já executada com checksum diferente e não reconhecido: {existingChecksum}.");
                    }

                    await ExecuteScriptAsync(connection, script, ct);
                }

                var postConditionValidator = new MigrationPostConditionValidator();
                foreach (var knownHistorical in historicalMigrationsToValidate)
                {
                    await postConditionValidator.ValidateAsync(connection, knownHistorical);
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

        DO $$
        DECLARE
            has_table boolean;
            has_script_name boolean;
            has_version boolean;
            has_aplicado_em boolean;
            has_applied_at boolean;
        BEGIN
            SELECT to_regclass('integrarp.schema_migrations') IS NOT NULL INTO has_table;
            IF has_table THEN
                SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='schema_migrations' AND column_name='script_name') INTO has_script_name;
                SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='schema_migrations' AND column_name='version') INTO has_version;
                SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='schema_migrations' AND column_name='aplicado_em') INTO has_aplicado_em;
                SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='schema_migrations' AND column_name='applied_at') INTO has_applied_at;

                IF has_version AND NOT has_script_name THEN
                    DROP TABLE IF EXISTS integrarp.schema_migrations_legacy;
                    ALTER TABLE integrarp.schema_migrations RENAME TO schema_migrations_legacy;
                END IF;
            END IF;

            CREATE TABLE IF NOT EXISTS integrarp.schema_migrations (
              migration_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
              script_name varchar(260) UNIQUE NOT NULL,
              checksum_sha256 varchar(128) NOT NULL,
              executed_at timestamptz NOT NULL DEFAULT now(),
              duration_ms bigint NOT NULL DEFAULT 0,
              success boolean NOT NULL DEFAULT true,
              error_message text NULL,
              executed_by varchar(160) NULL
            );

            IF to_regclass('integrarp.schema_migrations_legacy') IS NOT NULL THEN
                SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='schema_migrations_legacy' AND column_name='aplicado_em') INTO has_aplicado_em;
                SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='schema_migrations_legacy' AND column_name='applied_at') INTO has_applied_at;

                EXECUTE format(
                    'INSERT INTO integrarp.schema_migrations (script_name, checksum_sha256, executed_at, duration_ms, success, executed_by) SELECT version::text, %L || version::text, %s, 0, true, %L FROM integrarp.schema_migrations_legacy ON CONFLICT (script_name) DO NOTHING',
                    'legacy:',
                    CASE WHEN has_aplicado_em THEN 'COALESCE(aplicado_em, now())' WHEN has_applied_at THEN 'COALESCE(applied_at, now())' ELSE 'now()' END,
                    'legacy-upgrade');
            END IF;
        END $$;

        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS migration_id uuid DEFAULT gen_random_uuid();
        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS script_name varchar(260);
        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS checksum_sha256 varchar(128);
        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS executed_at timestamptz DEFAULT now();
        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS duration_ms bigint DEFAULT 0;
        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS success boolean DEFAULT true;
        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS error_message text;
        ALTER TABLE integrarp.schema_migrations ADD COLUMN IF NOT EXISTS executed_by varchar(160);

        UPDATE integrarp.schema_migrations
           SET migration_id = COALESCE(migration_id, gen_random_uuid()),
               checksum_sha256 = COALESCE(checksum_sha256, 'legacy:' || script_name),
               executed_at = COALESCE(executed_at, now()),
               duration_ms = COALESCE(duration_ms, 0),
               success = COALESCE(success, true),
               executed_by = COALESCE(executed_by, 'legacy-upgrade');

        CREATE UNIQUE INDEX IF NOT EXISTS ux_schema_migrations_script_name_idx ON integrarp.schema_migrations(script_name);
        CREATE INDEX IF NOT EXISTS ix_schema_migrations_success_executed_at ON integrarp.schema_migrations(success, executed_at DESC);
        """);
}