using IntegraRP.Domain.Bi;
using IntegraRP.Domain.Project;

namespace IntegraRP.Tests;

public sealed class Sprint7BiProjectTests
{
    [Fact]
    public void Migration_0007_exists_and_uses_integrarp_schema()
    {
        var sql = File.ReadAllText(Path.Combine("..", "..", "..", "..", "database", "migrations", "0007_bi_kpis_project_central.sql"));
        Assert.Contains("integrarp.kpi_definicao", sql);
        Assert.Contains("integrarp.projeto_central_board", sql);
        Assert.Contains("integrarp.vw_projeto_central_resumo", sql);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Kpi_domain_validates_code_and_score_status()
    {
        Assert.Throws<ArgumentException>(() => new KpiDefinition(Guid.NewGuid(), null, "", "KPI", "BI", KpiUnit.Quantidade));
        var kpi = new KpiDefinition(Guid.NewGuid(), null, "tarefas", "Tarefas", "BI", KpiUnit.Quantidade);
        Assert.True(kpi.PodeCalcular());
        Assert.Equal(KpiStatus.Positivo, kpi.CalcularStatus(10, 5));
        Assert.Equal(KpiStatus.Negativo, kpi.CalcularStatus(3, 5));
        Assert.Equal(ScoreStatus.Critico, new ScoreValue(49).Status);
        Assert.Equal(ScoreStatus.Positivo, new ScoreValue(90).Status);
    }

    [Fact]
    public void Project_domain_validates_and_moves_items()
    {
        Assert.Throws<ArgumentException>(() => new ProjectBoard(Guid.NewGuid(), Guid.NewGuid(), ""));
        Assert.Throws<ArgumentException>(() => new ProjectSprint(Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), "S", "Sprint", new DateOnly(2026, 2, 1), new DateOnly(2026, 1, 1)));
        Assert.Throws<ArgumentException>(() => new ProjectItem(Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), "S7", "", 1));
        Assert.Throws<ArgumentException>(() => new ProjectItem(Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), "S7", "Item", -1));
        var item = new ProjectItem(Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), "S7", "Item", 3);
        var feed = item.MoveTo(Guid.NewGuid(), true);
        Assert.NotNull(item.ConcluidoEm);
        Assert.Equal(ProjectFeedEventType.ItemMovido, feed.Tipo);
        item.MoveTo(Guid.NewGuid(), false);
        Assert.Null(item.ConcluidoEm);
        item.Excluir();
        Assert.NotNull(item.ExcluidoEm);
    }
}
