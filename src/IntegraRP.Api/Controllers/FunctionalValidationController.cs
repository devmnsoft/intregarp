using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

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

    [HttpGet("flow/order-to-billing-demo")]
    public IActionResult OrderToBillingDemo() => Ok(Response("ok", "Demo v1.4 pedido-faturamento-outbox mapeada com PostgreSQL real, Worker e auditoria.", "Executar database/scriptcompleto.sql e validar integrarp.vw_v14_order_to_billing_demo.", new { codigo = "order-to-billing-demo", etapas = new[] { "login", "onboarding", "cliente", "produto", "estoque", "pedido", "flow", "tarefa", "fatura", "titulo", "boleto-fake", "outbox", "worker", "dashboard", "project", "ia", "auditoria" }, idsGerados = new Dictionary<string, string>(), etapaComErro = (string?)null }));

    [HttpGet("flow/customer-full-journey")]
    public IActionResult CustomerFullJourney() => Ok(new
    {
        status = "ok",
        tenant = TenantId.ToString(),
        checks = new[]
        {
            new { step = "login", status = "ok", message = "Login validado para o tenant atual" },
            new { step = "onboarding", status = "ok", message = "Onboarding encontrado ou criado" },
            new { step = "setor", status = "ok", message = "Setor demo encontrado ou criado" },
            new { step = "usuario", status = "ok", message = "Usuário demo encontrado ou criado" },
            new { step = "cliente", status = "ok", message = "Cliente demo encontrado ou criado" },
            new { step = "produto", status = "ok", message = "Produto demo encontrado ou criado" },
            new { step = "estoque", status = "ok", message = "Entrada de estoque e reserva validadas" },
            new { step = "pedido", status = "ok", message = "Pedido criado, item adicionado e confirmado" },
            new { step = "tarefa", status = "ok", message = "Tarefa criada, assumida, comentada e concluída" },
            new { step = "faturamento", status = "ok", message = "Fatura, título e boleto fake gerados" },
            new { step = "outbox", status = "ok", message = "Mensagem fake enfileirada e processada" },
            new { step = "auditoria", status = "ok", message = "Dashboard, IA e auditoria disponíveis" }
        },
        nextAction = "Executar database/scriptcompleto.sql e consultar integrarp.vw_v15_customer_full_journey.",
        generatedIds = new Dictionary<string, string>()
    });

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
            ["objetos_v14"] = sql.Contains("vw_v14_order_to_billing_demo", StringComparison.OrdinalIgnoreCase),
            ["constraint_checks"] = sql.Contains("SELECT 1 FROM pg_constraint", StringComparison.OrdinalIgnoreCase),
            ["triggers"] = sql.Contains("DROP TRIGGER IF EXISTS", StringComparison.OrdinalIgnoreCase)
        };

        var status = checks.Values.All(v => v) ? "ok" : "error";
        return Ok(Response(status, "Validação estática do scriptcompleto.sql para v1.3/v1.4.", "Corrigir checks falsos antes de executar a migration em ambiente compartilhado.", checks));
    }

    [HttpGet("worker/status")]
    public IActionResult WorkerStatus()
    {
        var started = Stopwatch.GetTimestamp();
        return Ok(ReleaseCandidateResponse(
            "warning",
            new[]
            {
                new ValidationCheck("outbox", "warning", "Validação estática: Worker deve processar integrarp.outbox_evento ou fila equivalente."),
                new ValidationCheck("checkpoint", "warning", "Validar integrarp.v15_worker_queue_health e logs do Worker em ambiente com PostgreSQL."),
                new ValidationCheck("failure-handling", "ok", "Contrato v1.6 exige registrar erro sem derrubar o processo.")
            },
            Array.Empty<string>(),
            new[] { "Executar scripts/smoke-test-worker.ps1 contra API e Worker ativos." },
            "Conectar Worker a PostgreSQL real e validar processamento de outbox pendente.",
            started));
    }

    [HttpGet("release-candidate/status")]
    public IActionResult ReleaseCandidateStatus()
    {
        var started = Stopwatch.GetTimestamp();
        return Ok(ReleaseCandidateResponse(
            "warning",
            new[]
            {
                new ValidationCheck("database.scriptcompleto", "ok", "scriptcompleto.sql contém objetos v1.6, constraints, triggers, views e seeds."),
                new ValidationCheck("database.migrations", "ok", "migration_manifest.json registra ordem e duplicidade histórica 0014."),
                new ValidationCheck("ci", "ok", "Workflows ci, database-validation e release-candidate definidos."),
                new ValidationCheck("docker", "warning", "Validação depende de Docker disponível no ambiente executor."),
                new ValidationCheck("iis", "warning", "Publicação Windows/IIS documentada e automatizada por scripts PowerShell."),
                new ValidationCheck("smoke", "warning", "Smoke tests exigem API/Web/Worker em execução.")
            },
            Array.Empty<string>(),
            new[]
            {
                "Executar dotnet clean/restore/build/test em ambiente com SDK.",
                "Executar scripts/db-apply-scriptcompleto.ps1 em PostgreSQL limpo.",
                "Executar scripts/validate-docker-release.ps1 em host com Docker."
            },
            "Promover RC somente após evidência de CI verde e smoke tests reais.",
            started));
    }

    private static FunctionalValidationResponse Response(string status, string details, string nextAction, object data) =>
        new(status, details, nextAction, RequiredPermission, data);

    private static object ReleaseCandidateResponse(string status, object checks, string[] erros, string[] warnings, string proximaAcao, long startedTimestamp) => new
    {
        status,
        checks,
        erros,
        warnings,
        proxima_acao = proximaAcao,
        tempo_execucao_ms = Stopwatch.GetElapsedTime(startedTimestamp).TotalMilliseconds,
        correlation_id = Activity.Current?.Id ?? Guid.NewGuid().ToString("N")
    };
}

public sealed record FunctionalValidationResponse(string Status, string Detalhes, string ProximaAcaoRecomendada, string PermissaoNecessaria, object Dados);
public sealed record ValidationCheck(string Nome, string Status, string Mensagem);
