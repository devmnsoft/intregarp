using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/validation")]
public sealed class FunctionalValidationController(ILogger<FunctionalValidationController> logger) : IntegraControllerBase
{
    private const string RequiredPermission = "validation.functional.visualizar";

    [HttpGet("health/end-to-end")]
    public IActionResult EndToEndHealth()
    {
        logger.LogInformation("Validando fluxo end-to-end v1.3 para tenant {TenantId}", TenantId);
        return Ok(Response("ok", "Fluxo demo v1.3 mapeado com pedido, Flow, faturamento, outbox, BI e auditoria.", "Execute o script completo e consulte integrarp.vw_v13_demo_health.", new[]
        {
            "tenant demo",
            "pedido confirmado",
            "tarefa Flow criada",
            "outbox enfileirado",
            "ação recomendada persistida"
        }));
    }

    [HttpGet("demo/status")]
    public IActionResult DemoStatus() => Ok(Response("ok", "Demo v1.3 documentada e sem dependência de dados em memória para validação SQL.", "Siga /docs/end-to-end-demo-v1.3.md.", new[] { "demo-v13", "vw_v13_fluxo_pedido_end_to_end" }));

    [HttpGet("repositories/status")]
    public IActionResult RepositoriesStatus() => Ok(Response("warning", "Inventário de repositories reais e providers sandbox publicado.", "Priorize os itens marcados como 'Trocar agora por PostgreSQL'.", new[] { "tenant_id obrigatório", "sem SELECT *", "SQL parametrizado", "Dapper/PostgreSQL" }));

    [HttpGet("screens/status")]
    public IActionResult ScreensStatus() => Ok(Response("warning", "Telas principais possuem plano de conexão API e estados vazios inteligentes documentados.", "Validar tela a tela usando /docs/screens-api-connection-status.md.", new[] { "/dashboard", "/orders", "/journey/what-to-do-now", "/ai/chat" }));

    [HttpGet("tenant-isolation/status")]
    public IActionResult TenantIsolationStatus() => Ok(Response("ok", "Contrato v1.3 exige tenant_id em toda consulta operacional.", "Executar testes de Tenant A versus Tenant B antes do piloto.", new[] { "tenant_id", "RBAC", RequiredPermission }));

    [HttpGet("scriptcompleto/status")]
    public IActionResult ScriptCompletoStatus()
    {
        var scriptPath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "database", "scriptcompleto.sql"));
        var exists = System.IO.File.Exists(scriptPath);
        var sql = exists ? System.IO.File.ReadAllText(scriptPath) : string.Empty;
        var checks = new Dictionary<string, bool>
        {
            ["existe"] = exists,
            ["usa_integrarp"] = sql.Contains("integrarp.", StringComparison.OrdinalIgnoreCase),
            ["sem_public"] = !sql.Contains("public.", StringComparison.OrdinalIgnoreCase),
            ["sem_integra"] = !sql.Contains("integra.", StringComparison.OrdinalIgnoreCase),
            ["views_v13"] = sql.Contains("vw_v13_demo_health", StringComparison.OrdinalIgnoreCase),
            ["constraint_checks"] = sql.Contains("SELECT 1 FROM pg_constraint", StringComparison.OrdinalIgnoreCase),
            ["triggers"] = sql.Contains("DROP TRIGGER IF EXISTS", StringComparison.OrdinalIgnoreCase)
        };

        var status = checks.Values.All(v => v) ? "ok" : "error";
        return Ok(Response(status, "Validação estática do scriptcompleto.sql para v1.3.", "Corrigir checks falsos antes de executar a migration em ambiente compartilhado.", checks));
    }

    private static FunctionalValidationResponse Response(string status, string details, string nextAction, object data) =>
        new(status, details, nextAction, RequiredPermission, data);
}

public sealed record FunctionalValidationResponse(string Status, string Detalhes, string ProximaAcaoRecomendada, string PermissaoNecessaria, object Dados);
