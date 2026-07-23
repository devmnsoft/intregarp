namespace IntegraRP.Infrastructure.Data.Migrations;

public sealed class MigrationCompatibilityPlan
{
    private readonly IReadOnlyDictionary<(string ScriptName, string Checksum), KnownHistoricalMigration> migrations;

    public MigrationCompatibilityPlan(IEnumerable<KnownHistoricalMigration> knownMigrations)
    {
        migrations = knownMigrations.ToDictionary(
            item => (item.ScriptName, item.LegacyChecksumSha256),
            item => item,
            new MigrationCompatibilityKeyComparer());
    }

    public static MigrationCompatibilityPlan V127() => new([
        new("0029_v123_core_operacional_real.sql", "edb3ca5b3b1ff6413824efcaba388b5f46868812124b27f9d40c55a1df0f660e", string.Empty,
            "Objetos operacionais canônicos completos para upgrades v1.23.", "0033_v127_operacao_comercial_executavel.sql", "SELECT 1 WHERE to_regclass('integrarp.vw_dashboard_operacional') IS NOT NULL"),
        new("0030_v124_production_foundation_auth_ux.sql", "a35cbcaf3af9e63b36234f862f3f477f97b340200355ce7ca05a566bf6ea6cf2", string.Empty,
            "Auth, sessão e hardening mantidos por correção aditiva.", "0033_v127_operacao_comercial_executavel.sql", "SELECT 1 WHERE to_regclass('integrarp.auth_sessao') IS NOT NULL"),
        new("0031_v125_core_comercial_ux_operacional.sql", "a900480526dfe266eab0ac691cbf3b660e15673f60b6d6d7ae8934ba39f11c23", string.Empty,
            "Objetos v125 reconciliados para fontes canônicas.", "0033_v127_operacao_comercial_executavel.sql", "SELECT 1 WHERE to_regclass('integrarp.auditoria_evento') IS NOT NULL AND to_regclass('integrarp.outbox_evento') IS NOT NULL"),
    ]);

    public KnownHistoricalMigration? Find(string scriptName, string checksumSha256) =>
        migrations.TryGetValue((scriptName, checksumSha256), out var migration) ? migration : null;

    private sealed class MigrationCompatibilityKeyComparer : IEqualityComparer<(string ScriptName, string Checksum)>
    {
        public bool Equals((string ScriptName, string Checksum) x, (string ScriptName, string Checksum) y) =>
            StringComparer.OrdinalIgnoreCase.Equals(x.ScriptName, y.ScriptName) &&
            StringComparer.OrdinalIgnoreCase.Equals(x.Checksum, y.Checksum);

        public int GetHashCode((string ScriptName, string Checksum) obj) =>
            HashCode.Combine(StringComparer.OrdinalIgnoreCase.GetHashCode(obj.ScriptName), StringComparer.OrdinalIgnoreCase.GetHashCode(obj.Checksum));
    }
}
