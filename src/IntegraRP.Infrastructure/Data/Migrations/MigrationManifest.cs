using System.Text.Json;
using System.Text.Json.Serialization;

namespace IntegraRP.Infrastructure.Data.Migrations;

public sealed record MigrationManifest(
    [property: JsonPropertyName("schema")] string Schema,
    [property: JsonPropertyName("gerado_para")] string GeneratedFor,
    [property: JsonPropertyName("contrato")] string Contract,
    [property: JsonPropertyName("migrations")] IReadOnlyList<MigrationManifestEntry> Migrations);

public sealed record MigrationManifestEntry(
    [property: JsonPropertyName("ordem")] int Order,
    [property: JsonPropertyName("arquivo")] string File,
    [property: JsonPropertyName("versao")] string Version,
    [property: JsonPropertyName("descricao")] string Description,
    [property: JsonPropertyName("modulo")] string Module,
    [property: JsonPropertyName("presente_no_script_completop")] bool PresentInScriptCompletop,
    [property: JsonPropertyName("status")] string Status,
    [property: JsonPropertyName("observacoes")] string Notes);

public static class MigrationManifestLoader
{
    public static MigrationManifest Load(string path)
        => JsonSerializer.Deserialize<MigrationManifest>(File.ReadAllText(path), new JsonSerializerOptions { PropertyNameCaseInsensitive = true })
           ?? throw new InvalidOperationException("Manifesto de migrations inválido.");
}

public sealed class MigrationManifestValidator
{
    private static readonly HashSet<string> HistoricalDuplicatePrefixes = new(StringComparer.OrdinalIgnoreCase) { "0014", "0020", "0021" };

    public IReadOnlyList<string> Validate(MigrationManifest manifest, string migrationsDirectory)
    {
        var errors = new List<string>();
        var directoryFiles = Directory.Exists(migrationsDirectory)
            ? Directory.GetFiles(migrationsDirectory, "*.sql").Select(Path.GetFileName).Where(x => x is not null).Select(x => x!).ToHashSet(StringComparer.OrdinalIgnoreCase)
            : new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (var group in manifest.Migrations.GroupBy(x => x.Order).Where(x => x.Count() > 1)) errors.Add($"ordem duplicada: {group.Key}");
        foreach (var group in manifest.Migrations.GroupBy(x => x.File, StringComparer.OrdinalIgnoreCase).Where(x => x.Count() > 1)) errors.Add($"arquivo duplicado: {group.Key}");
        foreach (var entry in manifest.Migrations)
        {
            if (!directoryFiles.Contains(entry.File)) errors.Add($"arquivo ausente: {entry.File}");
        }
        foreach (var extra in directoryFiles.Except(manifest.Migrations.Select(x => x.File), StringComparer.OrdinalIgnoreCase)) errors.Add($"arquivo excedente: {extra}");
        foreach (var prefixGroup in manifest.Migrations.GroupBy(x => x.File.Length >= 4 ? x.File[..4] : x.File, StringComparer.OrdinalIgnoreCase).Where(x => x.Count() > 1))
        {
            var prefix = prefixGroup.Key;
            var allMarked = prefixGroup.All(x => x.Status.Equals("versionada-duplicidade-historica", StringComparison.OrdinalIgnoreCase) || HistoricalDuplicatePrefixes.Contains(prefix));
            if (!HistoricalDuplicatePrefixes.Contains(prefix) || !allMarked) errors.Add($"prefixo duplicado não permitido: {prefix}");
        }
        return errors;
    }
}
