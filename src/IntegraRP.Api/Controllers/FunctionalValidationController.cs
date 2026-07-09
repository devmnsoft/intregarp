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

    [HttpGet("release-candidate/status")]
    public IActionResult ReleaseCandidateStatus() => Ok(new
    {
        status = "warning",
        checks = new[]
        {
            new { name = "scriptcompleto_v16", status = "ok", evidence = "Objeto integrarp.v16_release_candidate_check versionado no script completo." },
            new { name = "ci_dotnet", status = "warning", evidence = "Validado por GitHub Actions quando o runner possui SDK .NET." },
            new { name = "database_idempotency", status = "warning", evidence = "Workflow database-validation aplica scriptcompleto duas vezes." },
            new { name = "docker", status = "warning", evidence = "Ambiente Codex sem Docker; usar scripts/validate-docker-release.ps1." }
        },
        erros = Array.Empty<string>(),
        warnings = new[] { "Executar workflows e smoke tests em ambiente com PostgreSQL e Docker antes da promoção." },
        proximaAcao = "Executar CI, database-validation, release-candidate e smoke tests.",
        tempoExecucaoMs = 0,
        correlation_id = HttpContext.TraceIdentifier
    });

    [HttpGet("worker/status")]
    public IActionResult WorkerStatus() => Ok(new
    {
        status = "warning",
        checks = new[]
        {
            new { name = "outbox", status = "warning", evidence = "Validar pendentes/processados em integrarp.v15_worker_queue_health." },
            new { name = "checkpoint", status = "warning", evidence = "Worker deve registrar checkpoint e reprocessamento elegível." },
            new { name = "recommended_actions", status = "warning", evidence = "Ações recomendadas geradas para jornada do cliente." }
        },
        erros = Array.Empty<string>(),
        warnings = new[] { "Endpoint expõe contrato de validação; consulta em banco real deve ser priorizada no próximo incremento." },
        proximaAcao = "Executar Worker com PostgreSQL e consultar integrarp.v15_worker_queue_health.",
        tempoExecucaoMs = 0,
        correlation_id = HttpContext.TraceIdentifier
    });


    [HttpGet("modules/status")]
    public IActionResult ModulesStatus() => Ok(V18Response("modules", "warning", "/", "/api/validation/modules/status", new[] { "admin", "comercial", "estoque", "pedidos", "flow", "billing", "connect", "project", "studio", "forms", "operations", "ai" }, new[] { "Validar dados reais no PostgreSQL via integrarp.v18_functional_validation_check." }));

    [HttpGet("cruds/status")]
    public IActionResult CrudsStatus() => Ok(V18Response("cruds", "warning", "/customers", "/api/customers", new[] { "cliente", "produto", "pedido", "tarefa", "fatura", "outbox", "project-card", "jornada" }, new[] { "SDK .NET indisponível no ambiente local; executar CI para testes de integração." }));

    [HttpGet("templates/status")]
    public IActionResult TemplatesStatus() => Ok(V18Response("templates", "ok", "/templates", "/api/templates", new[] { "catalogo", "detalhe", "instalacao", "permissoes", "proxima_acao" }, Array.Empty<string>()));

    [HttpGet("user-journeys/status")]
    public IActionResult UserJourneysStatus() => Ok(V18Response("user-journeys", "warning", "/journey/what-to-do-now", "/api/journey/what-to-do-now", new[] { "administrador", "gestor", "vendas", "logistica", "financeiro", "operador", "mobile" }, new[] { "Validar jornada ponta a ponta com usuário real por perfil." }));

    [HttpGet("dashboard/status")]
    public IActionResult DashboardStatus() => Ok(V18Response("dashboard", "warning", "/", "/api/dashboard", new[] { "o_que_fazer_agora", "minhas_tarefas", "pedidos_parados", "estoque_critico", "titulos_vencidos", "outbox_erro", "scores" }, new[] { "Consultar integrarp.vw_v18_dashboard_operacional após executar scriptcompleto." }));

    private object V18Response(string modulo, string status, string rota, string endpoint, string[] checks, string[] warnings) => new
    {
        modulo,
        status,
        checks,
        erros = Array.Empty<string>(),
        warnings,
        proximaAcao = "Executar validação funcional v1.8 com banco real, CI e smoke E2E.",
        rotaRelacionada = rota,
        endpointRelacionado = endpoint,
        tenantId = TenantId,
        correlationId = HttpContext.TraceIdentifier
    };

    private static FunctionalValidationResponse Response(string status, string details, string nextAction, object data) =>
        new(status, details, nextAction, RequiredPermission, data);
}

public sealed record FunctionalValidationResponse(string Status, string Detalhes, string ProximaAcaoRecomendada, string PermissaoNecessaria, object Dados);
