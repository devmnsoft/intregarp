namespace IntegraRP.Infrastructure.Data.Migrations;

public sealed record KnownHistoricalMigration(
    string ScriptName,
    string LegacyChecksumSha256,
    string CurrentChecksumSha256,
    string ExpectedSchemaState,
    string CorrectiveMigration,
    string PostConditionSql);
