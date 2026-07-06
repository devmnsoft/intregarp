using Xunit;

namespace IntegraRP.Tests;

public sealed class V12DatabaseTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");
    private static string Read(params string[] parts) => File.ReadAllText(Path.Combine(new[] { Root }.Concat(parts).ToArray()));

    [Fact]
    public void ScriptCompleto_Deve_Conter_V12_Idempotente_Somente_Integrarp()
    {
        var sql = Read("database", "scriptcompleto.sql");
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE EXTENSION IF NOT EXISTS pgcrypto", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION integrarp.fn_set_atualizado_em", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("IF NOT EXISTS (SELECT 1 FROM pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("secret_reference", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DANFE HTML fake demo", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void ScriptCompleto_Deve_Conter_Todas_As_Tabelas_V12()
    {
        var sql = Read("database", "scriptcompleto.sql");
        foreach (var table in V12Tables)
        {
            Assert.Contains($"integrarp.{table}", sql, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void ScriptCompleto_Deve_Conter_Permissoes_Rbac_V12()
    {
        var sql = Read("database", "scriptcompleto.sql");
        foreach (var permission in V12Permissions)
        {
            Assert.Contains(permission, sql, StringComparison.OrdinalIgnoreCase);
        }
    }

    [Fact]
    public void Migration0014_Deve_Existir_E_Conter_Tabelas_V12()
    {
        var sql = Read("database", "migrations", "0014_v12_integracoes_fiscal_conciliacao_rotas_offline.sql");
        foreach (var table in V12Tables)
        {
            Assert.Contains($"integrarp.{table}", sql, StringComparison.OrdinalIgnoreCase);
        }

        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
    }

    private static readonly string[] V12Tables =
    [
        "integracao_conector",
        "integracao_conector_configuracao",
        "integracao_credencial_referencia",
        "integracao_execucao",
        "integracao_execucao_log",
        "integracao_webhook_endpoint",
        "integracao_webhook_evento",
        "integracao_mapeamento_campo",
        "integracao_fila_saida",
        "integracao_fila_entrada",
        "fiscal_configuracao",
        "fiscal_documento",
        "fiscal_documento_item",
        "fiscal_documento_evento",
        "fiscal_emissao_lote",
        "fiscal_emissao_log",
        "fiscal_cancelamento",
        "fiscal_carta_correcao",
        "fiscal_serie",
        "fiscal_certificado_referencia",
        "fiscal_provedor",
        "financeiro_conta_bancaria",
        "financeiro_extrato_importacao",
        "financeiro_extrato_lancamento",
        "financeiro_conciliacao",
        "financeiro_conciliacao_item",
        "financeiro_baixa_sugerida",
        "financeiro_regra_conciliacao",
        "financeiro_alerta_inadimplencia",
        "financeiro_projecao_recebivel",
        "rota_otimizacao_execucao",
        "rota_otimizacao_parada",
        "rota_otimizacao_resultado",
        "rota_distancia_cache",
        "rota_regra_otimizacao",
        "rota_restricao",
        "rota_janela_entrega",
        "offline_dispositivo",
        "offline_pacote_sincronizacao",
        "offline_item_sincronizacao",
        "offline_conflito",
        "offline_resolucao_conflito",
        "offline_checkpoint",
        "offline_log",
    ];

    private static readonly string[] V12Permissions =
    [
        "integrations.connectors.visualizar",
        "integrations.connectors.criar",
        "integrations.connectors.editar",
        "integrations.connectors.testar",
        "integrations.executions.visualizar",
        "integrations.queue.processar",
        "fiscal.documents.visualizar",
        "fiscal.documents.criar",
        "fiscal.documents.validar",
        "fiscal.documents.emitir_fake",
        "fiscal.documents.cancelar",
        "fiscal.danfe.visualizar",
        "reconciliation.accounts.visualizar",
        "reconciliation.accounts.criar",
        "reconciliation.statements.importar",
        "reconciliation.suggest.visualizar",
        "reconciliation.confirmar",
        "reconciliation.rejeitar",
        "reconciliation.alerts.visualizar",
        "routing.optimize",
        "routing.apply",
        "routing.visualizar",
        "routing.reorder",
        "offline.device.registrar",
        "offline.package.baixar",
        "offline.sync.enviar",
        "offline.conflicts.visualizar",
        "offline.conflicts.resolver",
    ];
}
