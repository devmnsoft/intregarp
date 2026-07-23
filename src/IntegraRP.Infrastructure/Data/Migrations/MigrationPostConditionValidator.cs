using Dapper;

namespace IntegraRP.Infrastructure.Data.Migrations;

public sealed class MigrationPostConditionValidator
{
    public async Task ValidateAsync(System.Data.IDbConnection connection, KnownHistoricalMigration migration)
    {
        var result = await connection.ExecuteScalarAsync<int?>(migration.PostConditionSql);
        if (result is null)
        {
            throw new InvalidOperationException($"Migration histórica {migration.ScriptName} reconhecida pelo checksum {migration.LegacyChecksumSha256}, mas a pós-condição esperada não foi atendida após {migration.CorrectiveMigration}: {migration.ExpectedSchemaState}.");
        }
    }
}
