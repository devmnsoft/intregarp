namespace IntegraRP.Contracts.Bi;

public sealed record KpiDefinitionResponse(Guid Id, Guid? TenantId, string Codigo, string Nome, string Modulo, string Unidade, string Status);
public sealed record CreateKpiDefinitionRequest(string Codigo, string Nome, string Modulo, string Unidade, string? Descricao);
public sealed record UpdateKpiDefinitionRequest(string Nome, string Modulo, string Unidade, bool Ativo);
public sealed record KpiValueResponse(Guid Id, Guid KpiDefinitionId, decimal? ValorNumero, string Status, DateTimeOffset CalculadoEm);
public sealed record KpiTargetResponse(Guid Id, Guid KpiDefinitionId, decimal? ValorMeta);
public sealed record SetKpiTargetRequest(decimal? ValorMeta, decimal? FaixaPositivaMin, decimal? FaixaNegativaMax);
public sealed record KpiAlertResponse(Guid Id, string Codigo, string Mensagem, string Severidade, DateTimeOffset CriadoEm);
public sealed record DashboardCardResponse(string Titulo, decimal Valor, string Unidade, string Status, string Icone);
public sealed record DashboardChartResponse(string Titulo, string Tipo, IReadOnlyList<string> Labels, IReadOnlyList<decimal> Valores);
public sealed record OperationalScoreResponse(decimal Score, string Status, IReadOnlyDictionary<string, decimal> Componentes, DateTimeOffset CalculadoEm);
public sealed record ExecutiveDashboardResponse(OperationalScoreResponse Score, IReadOnlyList<DashboardCardResponse> Cards, IReadOnlyList<DashboardChartResponse> Charts, IReadOnlyList<string> Gargalos, IReadOnlyList<KpiAlertResponse> Alertas);
public sealed record FlowBiDashboardResponse(IReadOnlyList<DashboardCardResponse> Cards, IReadOnlyList<DashboardChartResponse> Charts);
public sealed record CommercialBiDashboardResponse(IReadOnlyList<DashboardCardResponse> Cards, IReadOnlyList<DashboardChartResponse> Charts);
public sealed record InventoryBiDashboardResponse(IReadOnlyList<DashboardCardResponse> Cards, IReadOnlyList<DashboardChartResponse> Charts);
public sealed record BillingBiDashboardResponse(IReadOnlyList<DashboardCardResponse> Cards, IReadOnlyList<DashboardChartResponse> Charts);
public sealed record ConnectBiDashboardResponse(IReadOnlyList<DashboardCardResponse> Cards, IReadOnlyList<DashboardChartResponse> Charts);
