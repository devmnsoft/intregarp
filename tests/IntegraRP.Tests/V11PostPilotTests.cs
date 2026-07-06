using IntegraRP.Domain.Attachments;
using IntegraRP.Domain.Automation;
using IntegraRP.Domain.Forms;
using IntegraRP.Domain.Notifications;
using IntegraRP.Domain.Reports;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V11PostPilotTests
{
    private static readonly string Root = Path.Combine("..", "..", "..", "..");

    [Fact]
    public void ScriptCompleto_Deve_Existir_E_Seguir_Regras_De_Schema_Idempotencia()
    {
        var path = Path.Combine(Root, "database", "scriptcompleto.sql");
        Assert.True(File.Exists(path), "scriptcompleto.sql deve existir em /database.");
        var sql = File.ReadAllText(path);

        Assert.Contains("CREATE SCHEMA IF NOT EXISTS integrarp", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TABLE IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ALTER TABLE", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("ADD COLUMN IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE INDEX IF NOT EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE FUNCTION", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE OR REPLACE VIEW", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("pg_constraint", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("DROP TRIGGER IF EXISTS", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("CREATE TRIGGER", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void ScriptCompleto_Deve_Conter_Modulos_E_Seeds_Demo_V11()
    {
        var sql = File.ReadAllText(Path.Combine(Root, "database", "scriptcompleto.sql"));
        string[] expected = ["-- Core", "-- Segurança", "-- Flow", "-- Studio", "-- Comercial", "-- Estoque", "-- Faturamento", "-- Connect", "-- BI", "-- Project", "-- Mobile", "-- IA", "-- Operações", "-- Forms", "-- Automação", "-- Anexos", "-- Notificações", "-- Relatórios", "Checklist de Visita Comercial", "Checklist de Entrega com POD", "Registro de Avaria", "Pesquisa de Satisfação", "Tarefa atrasada", "Ocorrência cria tarefa", "Pedidos por período", "Estoque crítico", "Títulos vencidos"];
        foreach (var text in expected) Assert.Contains(text, sql, StringComparison.OrdinalIgnoreCase);
        Assert.True(File.Exists(Path.Combine(Root, "database", "migrations", "0013_v11_scriptcompleto_forms_automation.sql")));
    }

    [Fact]
    public void Domain_V11_Deve_Modelar_Tenant_E_Casos_Principais()
    {
        var tenantId = Guid.NewGuid();
        var form = new FormDefinition(Guid.NewGuid(), tenantId, "Checklist", null, FormStatus.Draft);
        var automation = new AutomationRule(Guid.NewGuid(), tenantId, "Tarefa atrasada", true, 3);
        var attachment = new AttachmentFile(Guid.NewGuid(), tenantId, "pod.jpg", "image/jpeg", 128, ".jpg", new string('a', 64), "tenant/pod.jpg");
        var notification = new Notification(Guid.NewGuid(), tenantId, "task_overdue", "Tarefa atrasada", "Mensagem", DateTimeOffset.UtcNow);
        var report = new ReportDefinition(Guid.NewGuid(), tenantId, "Pedidos por período", "orders_by_period", true);

        Assert.Equal(tenantId, form.TenantId);
        Assert.True(automation.Enabled);
        Assert.Equal(".jpg", attachment.Extension);
        Assert.Equal("task_overdue", notification.EventCode);
        Assert.Equal("orders_by_period", report.QueryKey);
    }
}
