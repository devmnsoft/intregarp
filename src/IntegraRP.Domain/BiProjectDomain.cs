namespace IntegraRP.Domain.Bi;

public enum KpiUnit { Percentual, Quantidade, Moeda, Tempo, Score }
public enum KpiDirection { Maior, Menor, Faixa }
public enum KpiStatus { Positivo, Neutro, Negativo, Critico }
public enum KpiFrequency { TempoReal, Horaria, Diaria, Semanal, Mensal }
public enum ScoreStatus { Positivo, Neutro, Negativo, Critico }
public enum DashboardWidgetType { Card, Barras, Linha, Donut, Tabela }

public readonly record struct KpiCode
{
    public KpiCode(string value) => Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Código do KPI é obrigatório.", nameof(value)) : value.Trim();
    public string Value { get; }
}

public readonly record struct ScoreValue
{
    public ScoreValue(decimal value) => Value = Math.Clamp(value, 0, 100);
    public decimal Value { get; }
    public ScoreStatus Status => Value >= 85 ? ScoreStatus.Positivo : Value >= 70 ? ScoreStatus.Neutro : Value >= 50 ? ScoreStatus.Negativo : ScoreStatus.Critico;
}

public sealed class KpiDefinition
{
    public KpiDefinition(Guid id, Guid? tenantId, string codigo, string nome, string modulo, KpiUnit unidade, bool ativo = true)
    {
        Id = id == Guid.Empty ? Guid.NewGuid() : id;
        TenantId = tenantId;
        Codigo = new KpiCode(codigo);
        Nome = string.IsNullOrWhiteSpace(nome) ? throw new ArgumentException("Nome do KPI é obrigatório.", nameof(nome)) : nome.Trim();
        Modulo = string.IsNullOrWhiteSpace(modulo) ? throw new ArgumentException("Módulo do KPI é obrigatório.", nameof(modulo)) : modulo.Trim();
        Unidade = unidade;
        Ativo = ativo;
    }

    public Guid Id { get; }
    public Guid? TenantId { get; }
    public KpiCode Codigo { get; }
    public string Nome { get; }
    public string Modulo { get; }
    public KpiUnit Unidade { get; }
    public bool Ativo { get; private set; }
    public bool PodeCalcular() => Ativo;
    public KpiStatus CalcularStatus(decimal valor, decimal? meta) => meta is null ? KpiStatus.Neutro : valor >= meta ? KpiStatus.Positivo : KpiStatus.Negativo;
    public void Desativar() => Ativo = false;
}

public sealed record KpiValue(Guid Id, Guid TenantId, Guid KpiDefinitionId, DateTimeOffset PeriodoInicio, DateTimeOffset PeriodoFim, decimal? ValorNumero, KpiStatus Status);
public sealed record KpiTarget(Guid Id, Guid TenantId, Guid KpiDefinitionId, decimal? ValorMeta);
public sealed record KpiAlert(Guid Id, Guid TenantId, Guid KpiDefinitionId, string Mensagem, KpiStatus Status);
public sealed record KpiSnapshot(Guid Id, Guid TenantId, DateTimeOffset CriadoEm, string PayloadJson);
public sealed record OperationalScore(Guid Id, Guid TenantId, ScoreValue Score, DateTimeOffset PeriodoInicio, DateTimeOffset PeriodoFim);
public sealed record DashboardConfiguration(Guid Id, Guid TenantId, string Nome);
public sealed record DashboardWidget(Guid Id, Guid DashboardId, DashboardWidgetType Tipo, string Titulo);
public sealed record SavedReport(Guid Id, Guid TenantId, string Nome);
public sealed record AnalyticsEvent(Guid Id, Guid? TenantId, string Tipo, DateTimeOffset CriadoEm);
public sealed record AnalyticsAggregationLog(Guid Id, Guid? TenantId, string Status, DateTimeOffset CriadoEm);
