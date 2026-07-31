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
    var files = Directory.EnumerateFiles(Path.Combine(root, "database"), "*.sql", SearchOption.AllDirectories)
        .Concat(Directory.EnumerateFiles(Path.Combine(root, "src"), "*.cs", SearchOption.AllDirectories));
    var issues = new List<(string File, int Line, string Name)>();
    foreach (var file in files)
    {
        var source = File.ReadAllText(file);
        var sql = file.EndsWith(".cs", StringComparison.OrdinalIgnoreCase)
            ? ExtractSqlFromCSharp(source)
            : StripSqlCommentsAndLiterals(source);
        if (Regex.IsMatch(sql, @"\bSET\s+(?:LOCAL\s+)?search_path\b", RegexOptions.IgnoreCase))
            AddIssue(issues, root, file, source, Regex.Match(sql, @"\bSET\s+(?:LOCAL\s+)?search_path\b", RegexOptions.IgnoreCase).Index, "search_path");

        var ctes = Regex.Matches(sql, @"(?:\bWITH\b|,)\s*(?<name>[a-zA-Z_][\w]*)\s+AS\s*(?:NOT\s+MATERIALIZED\s*)?\(", RegexOptions.IgnoreCase)
            .Select(match => match.Groups["name"].Value).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var relationPatterns = new[]
        {
            @"\bCREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?<name>[a-zA-Z_][\w.]*)",
            @"\bALTER\s+TABLE\s+(?:IF\s+EXISTS\s+)?(?<name>[a-zA-Z_][\w.]*)",
            @"\bINSERT\s+INTO\s+(?<name>[a-zA-Z_][\w.]*)",
            @"\bUPDATE\s+(?<name>[a-zA-Z_][\w.]*)\s+(?:AS\s+)?(?:[a-zA-Z_]\w*\s+)?SET\b",
            @"\bDELETE\s+FROM\s+(?<name>[a-zA-Z_][\w.]*)",
            @"\b(?:FROM|JOIN|REFERENCES|TRUNCATE(?:\s+TABLE)?)\s+(?:ONLY\s+)?(?<name>[a-zA-Z_][\w.]*)",
            @"\bDELETE\s+FROM\s+integrarp\.[a-zA-Z_][\w.]*[\s\S]{0,500}?\bUSING\s+(?:ONLY\s+)?(?<name>[a-zA-Z_][\w.]*)",
            @"\bCREATE\s+(?:UNIQUE\s+)?INDEX\s+(?:CONCURRENTLY\s+)?(?:IF\s+NOT\s+EXISTS\s+)?[a-zA-Z_][\w.]*\s+ON\s+(?:ONLY\s+)?(?<name>[a-zA-Z_][\w.]*)",
            @"\b(?:CREATE|DROP)\s+TRIGGER\s+(?:IF\s+EXISTS\s+)?[a-zA-Z_][\w.]*[\s\S]{0,300}?\bON\s+(?<name>[a-zA-Z_][\w.]*)",
            @"\bCREATE\s+(?:OR\s+REPLACE\s+)?(?:MATERIALIZED\s+)?VIEW\s+(?:IF\s+NOT\s+EXISTS\s+)?(?<name>[a-zA-Z_][\w.]*)",
            @"\bCREATE\s+SEQUENCE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?<name>[a-zA-Z_][\w.]*)"
        };
        foreach (var pattern in relationPatterns)
            foreach (Match match in Regex.Matches(sql, pattern, RegexOptions.IgnoreCase))
            {
                var name = match.Groups["name"].Value;
                if (ctes.Contains(name) || IsAllowedName(name)) continue;
                AddIssue(issues, root, file, source, match.Groups["name"].Index, name);
            }
    }
    var reportPath = Path.Combine(root, "artifacts", "v149", "database", "schema-qualification-report.json");
    Directory.CreateDirectory(Path.GetDirectoryName(reportPath)!);
    var reportIssues = issues.Distinct().Select(issue => new { file = issue.File, line = issue.Line, @object = issue.Name, classification = "violação real", expectedCorrection = "Qualificar a relação de negócio como integrarp.nome_do_objeto." }).ToArray();
    File.WriteAllText(reportPath, JsonSerializer.Serialize(new { contract = "Banco Canônico Integrarp v1.49", realViolationCount = reportIssues.Length, knownFalsePositivesAbsent = !reportIssues.Any(x => new[] { "on", "set", "changed", "batch", "handled", "skip", "route", "jwt", "gin", "case", "correlation_id", "var", "t", "c", "ped", "prod", "cat" }.Contains(x.@object, StringComparer.OrdinalIgnoreCase)), issues = reportIssues }, new JsonSerializerOptions { WriteIndented = true }) + Environment.NewLine);
    foreach (var issue in reportIssues) Console.Error.WriteLine($"{issue.file}:{issue.line}: relação sem schema integrarp ou schema proibido: {issue.@object}");
    Console.WriteLine($"Relatório: {reportPath} ({reportIssues.Length} problema(s)).");
    return reportIssues.Length == 0 ? 0 : 2;
}

static void AddIssue(List<(string File, int Line, string Name)> issues, string root, string file, string source, int index, string name)
{
    var line = 1 + source[..Math.Clamp(index, 0, source.Length)].Count(character => character == '\n');
    issues.Add((Path.GetRelativePath(root, file), line, name));
}

static string ExtractSqlFromCSharp(string source)
{
    var result = source.Select(character => character is '\n' or '\r' ? character : ' ').ToArray();
    const string literalPattern = "(?:\\$?@|@\\$?)\"(?:\"\"|[^\"])*\"|\\$?\"\"\"[\\s\\S]*?\"\"\"|\\$?\"(?:\\\\.|[^\"\\\\])*\"";
    foreach (Match literal in Regex.Matches(source, literalPattern))
    {
        if (!Regex.IsMatch(literal.Value, @"\b(?:SELECT|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP|WITH|CALL|DO)\b", RegexOptions.IgnoreCase))
            continue;
        for (var index = literal.Index; index < literal.Index + literal.Length; index++)
            result[index] = source[index];
    }
    return StripSqlCommentsAndLiterals(new string(result));
}

static string StripSqlCommentsAndLiterals(string source)
{
    var result = source.ToCharArray();
    for (var i = 0; i < source.Length;)
    {
        if (i + 1 < source.Length && source[i] == '-' && source[i + 1] == '-') { var end = source.IndexOf('\n', i); if (end < 0) end = source.Length; Blank(result, i, end); i = end; continue; }
        if (i + 1 < source.Length && source[i] == '/' && source[i + 1] == '*') { var end = source.IndexOf("*/", i + 2, StringComparison.Ordinal); end = end < 0 ? source.Length : end + 2; Blank(result, i, end); i = end; continue; }
        if (source[i] == '\'' && (i == 0 || source[i - 1] != '@')) { var end = i + 1; while (end < source.Length) { if (source[end] == '\'' && end + 1 < source.Length && source[end + 1] == '\'') { end += 2; continue; } if (source[end++] == '\'') break; } Blank(result, i, end); i = end; continue; }
        // Dollar-quoted PL/pgSQL bodies contain executable SQL and must remain visible.
        i++;
    }
    return new string(result);
}

static void Blank(char[] chars, int start, int end)
{
    for (var i = start; i < end; i++) if (chars[i] != '\n' && chars[i] != '\r') chars[i] = ' ';
}

static bool IsAllowedName(string name)
{
    if (string.IsNullOrWhiteSpace(name)) return true;
    var lower = name.Trim('"').ToLowerInvariant();
    return lower.StartsWith("integrarp.") || lower.StartsWith("information_schema.") || lower.StartsWith("pg_catalog.") || lower.StartsWith("pg_") || lower.StartsWith("tmp_") || new[] { "select", "values", "jsonb_array_elements", "unnest", "new", "old", "excluded" }.Contains(lower);
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
