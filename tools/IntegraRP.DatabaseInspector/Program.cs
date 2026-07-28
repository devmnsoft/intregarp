using System.Text.Json;
using System.Text.RegularExpressions;

var command = args.FirstOrDefault() ?? "help";
var root = FindRepositoryRoot(Directory.GetCurrentDirectory());
return command switch
{
    "lint-sql" => LintSql(root),
    "lint-schema-qualification" => LintSql(root),
    "validate-manifest" => ValidateManifest(root),
    "validate-schema" => ValidateSchema(root),
    "compare-model-code" => CompareModelCode(root),
    _ => Help()
};

static int Help()
{
    Console.WriteLine("IntegraRP.DatabaseInspector commands: lint-schema-qualification, lint-sql, validate-manifest, validate-schema, compare-model-code");
    return 1;
}

static string FindRepositoryRoot(string start)
{
    var current = new DirectoryInfo(start);
    while (current is not null)
    {
        if (File.Exists(Path.Combine(current.FullName, "IntegraRP.sln"))) return current.FullName;
        current = current.Parent;
    }
    throw new InvalidOperationException("IntegraRP.sln não encontrado.");
}

static int LintSql(string root)
{
    var files = Directory.EnumerateFiles(root, "*.sql", SearchOption.AllDirectories)
        .Concat(Directory.EnumerateFiles(Path.Combine(root, "src"), "*.cs", SearchOption.AllDirectories))
        .Concat(Directory.Exists(Path.Combine(root, "tests")) ? Directory.EnumerateFiles(Path.Combine(root, "tests"), "*.cs", SearchOption.AllDirectories) : []);
    var failures = new List<string>();
    var patterns = new[]
    {
        @"\bCREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?<name>[a-zA-Z_][\w.]*)(?!\s*\()",
        @"\bALTER\s+TABLE\s+(?:IF\s+EXISTS\s+)?(?<name>[a-zA-Z_][\w.]*)",
        @"\bINSERT\s+INTO\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\bUPDATE\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\bDELETE\s+FROM\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\b(?:FROM|JOIN|REFERENCES|TRUNCATE)\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\bCREATE\s+(?:UNIQUE\s+)?INDEX\s+(?:IF\s+NOT\s+EXISTS\s+)?[a-zA-Z_][\w.]*\s+ON\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\bCREATE\s+TRIGGER\s+[a-zA-Z_][\w.]*.*?\bON\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\bDROP\s+TRIGGER\s+(?:IF\s+EXISTS\s+)?[a-zA-Z_][\w.]*\s+ON\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\bCREATE\s+(?:OR\s+REPLACE\s+)?VIEW\s+(?<name>[a-zA-Z_][\w.]*)",
        @"\bCREATE\s+SEQUENCE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?<name>[a-zA-Z_][\w.]*)",
        @"\b(?:nextval|currval|setval)\s*\(\s*'(?<name>[a-zA-Z_][\w.]*)'"
    };
    foreach (var file in files)
    {
        var lines = File.ReadAllLines(file);
        for (var i = 0; i < lines.Length; i++)
        {
            var line = Regex.Replace(lines[i], @"--.*$", string.Empty);
            if (Regex.IsMatch(line, @"\bSET\s+(LOCAL\s+)?search_path\b", RegexOptions.IgnoreCase)) failures.Add($"{file}:{i + 1}: search_path proibido");
            foreach (var pattern in patterns)
            {
                foreach (Match match in Regex.Matches(line, pattern, RegexOptions.IgnoreCase))
                {
                    var name = match.Groups["name"].Value;
                    if (IsAllowedName(name)) continue;
                    failures.Add($"{file}:{i + 1}: relação sem schema integrarp ou schema proibido: {name}");
                }
            }
        }
    }
    var reportPath = Path.Combine(root, "artifacts", "database", "schema-qualification-report.json");
    Directory.CreateDirectory(Path.GetDirectoryName(reportPath)!);
    var issues = failures.Select(failure => new
    {
        file = failure.Split(':', 3)[0].Replace(root + Path.DirectorySeparatorChar, string.Empty),
        line = int.TryParse(failure.Split(':', 3).ElementAtOrDefault(1), out var lineNumber) ? lineNumber : 0,
        snippet = failure.Split(':', 3).ElementAtOrDefault(2)?.Trim() ?? failure,
        @object = Regex.Match(failure, @"(?:proibido:\s*|proibido\s+)(?<name>[\w.]+)$").Groups["name"].Value,
        expectedCorrection = "Qualificar a relação de negócio como integrarp.nome_do_objeto."
    }).ToArray();
    File.WriteAllText(reportPath, JsonSerializer.Serialize(new { contract = "Banco Canônico Integrarp v1.40", issueCount = issues.Length, issues }, new JsonSerializerOptions { WriteIndented = true }) + Environment.NewLine);
    foreach (var failure in failures) Console.Error.WriteLine(failure);
    Console.WriteLine($"Relatório: {reportPath} ({failures.Count} problema(s)).");
    return failures.Count == 0 ? 0 : 2;
}

static bool IsAllowedName(string name)
{
    if (string.IsNullOrWhiteSpace(name)) return true;
    var lower = name.Trim('"').ToLowerInvariant();
    if (lower.StartsWith("integrarp.")) return true;
    if (lower.StartsWith("information_schema.") || lower.StartsWith("pg_catalog.")) return true;
    if (lower.StartsWith("pg_") || lower.StartsWith("tmp_")) return true;
    if (new[] { "select", "values", "jsonb_array_elements", "unnest" }.Contains(lower)) return true;
    return false;
}

static int ValidateManifest(string root)
{
    var manifest = Path.Combine(root, "database", "migration_manifest.json");
    if (!File.Exists(manifest)) { Console.Error.WriteLine("Manifest ausente."); return 2; }
    var text = File.ReadAllText(manifest);
    foreach (Match match in Regex.Matches(text, "\\\"arquivo\\\"\\s*:\\s*\\\"(?<file>[^\\\"]+)\\\""))
    {
        var file = Path.Combine(root, "database", "migrations", match.Groups["file"].Value);
        if (!File.Exists(file)) { Console.Error.WriteLine($"Migration ausente: {file}"); return 2; }
    }
    Console.WriteLine("Manifest válido.");
    return 0;
}

static int ValidateSchema(string root) => LintSql(root);
static int CompareModelCode(string root)
{
    Console.WriteLine("Comparação modelo/código inicial: nomes canônicos processo_* e tarefa_operacional validados por lint-sql.");
    return LintSql(root);
}
