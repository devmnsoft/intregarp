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
        new("0029_v123_core_operacional_real.sql", "edb3ca5b3b1ff6413824efcaba388b5f46868812124b27f9d40c55a1df0f660e", "DCFD5043778B4278BAADE8D049A95AE62A54E60683BB45CB432A33C44B8D9808",
            "0033_v127_operacao_comercial_executavel.sql", "Objetos operacionais canônicos completos para upgrades v1.23.", """
            SELECT 1
            WHERE EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_usuario_tenant_id_id')
              AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='usuario_historico_senha' AND column_name='usuario_id')
              AND EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname='integrarp' AND indexname ILIKE '%usuario%tenant%')
            """, 33),
        new("0030_v124_production_foundation_auth_ux.sql", "a35cbcaf3af9e63b36234f862f3f477f97b340200355ce7ca05a566bf6ea6cf2", "FE6BA13C72222FB41E31C0A62FA89A37F182CB1D794D34E622FBBF037EBD2D6D",
            "0033_v127_operacao_comercial_executavel.sql", "Auth, sessão e hardening mantidos por correção aditiva.", """
            SELECT 1
            WHERE EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='auth_sessao' AND column_name='motivo')
              AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='auth_sessao' AND column_name='reason' AND is_nullable='YES')
              AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='auth_sessao' AND column_name='correlation_id')
              AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='auth_sessao' AND column_name='user_agent')
              AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='usuario' AND column_name='security_stamp')
            """, 33),
        new("0031_v125_core_comercial_ux_operacional.sql", "a900480526dfe266eab0ac691cbf3b660e15673f60b6d6d7ae8934ba39f11c23", "A4AD115BBC33C0E1B326B79E3F7D5048600D1C31246B97B3DFA07718FAB8A187",
            "0033_v127_operacao_comercial_executavel.sql", "Objetos v125 reconciliados para fontes canônicas.", """
            SELECT 1
            WHERE EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='auditoria_evento' AND column_name='correlation_id')
              AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='integrarp' AND table_name='outbox_evento' AND column_name='idempotency_key')
              AND to_regclass('integrarp.worker_tenant_job_lock') IS NOT NULL
              AND to_regclass('integrarp.worker_dead_letter') IS NOT NULL
            """, 33),
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
