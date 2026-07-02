using Dapper;
using System.Data;

namespace IntegraRP.Infrastructure.Data.Migrations;

public sealed class MigrationHistoryRepository(IDbConnection connection, IDbTransaction? transaction = null)
{
    public Task<string?> GetChecksumAsync(string scriptName) => connection.QuerySingleOrDefaultAsync<string>(
        "SELECT checksum_sha256 FROM integrarp.schema_migrations WHERE script_name = @scriptName AND success = true",
        new { scriptName },
        transaction);

    public Task RegisterSuccessAsync(MigrationScript script, long durationMs, string? executedBy) => connection.ExecuteAsync(
        """
        INSERT INTO integrarp.schema_migrations (script_name, checksum_sha256, duration_ms, success, executed_by)
        VALUES (@Name, @ChecksumSha256, @durationMs, true, @executedBy)
        ON CONFLICT (script_name) DO UPDATE
        SET checksum_sha256 = EXCLUDED.checksum_sha256,
            executed_at = now(),
            duration_ms = EXCLUDED.duration_ms,
            success = true,
            error_message = NULL,
            executed_by = EXCLUDED.executed_by
        """,
        new { script.Name, script.ChecksumSha256, durationMs, executedBy },
        transaction);

    public Task RegisterFailureAsync(MigrationScript script, long durationMs, string error, string? executedBy) => connection.ExecuteAsync(
        """
        INSERT INTO integrarp.schema_migrations (script_name, checksum_sha256, duration_ms, success, error_message, executed_by)
        VALUES (@Name, @ChecksumSha256, @durationMs, false, @error, @executedBy)
        ON CONFLICT (script_name) DO UPDATE
        SET executed_at = now(),
            duration_ms = EXCLUDED.duration_ms,
            success = false,
            error_message = EXCLUDED.error_message,
            executed_by = EXCLUDED.executed_by
        """,
        new { script.Name, script.ChecksumSha256, durationMs, error, executedBy },
        transaction);
}
