using System.Text.Json;
using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Contracts.Bi;
using IntegraRP.Contracts.Project;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Services.Sprint7;

public sealed class InMemoryBiProjectService(ILogger<InMemoryBiProjectService> logger) : ISprint7BiProjectService
{
    private readonly Guid _tenant = Guid.Parse("11111111-1111-1111-1111-111111111111");
    private readonly List<KpiDefinitionResponse> _kpis = [];
    private readonly List<ProjectBoardResponse> _boards = [];
    private readonly List<ProjectSprintResponse> _sprints = [];
    private readonly List<ProjectFeedEventResponse> _feed = [];

    private IReadOnlyList<DashboardCardResponse> Cards =>
    [
        new("Tarefas atrasadas", 3, "quantidade", "negativo", "bi-alarm"),
        new("Processos atrasados", 2, "quantidade", "neutro", "bi-diagram-3"),
        new("Pedidos em aberto", 18, "quantidade", "neutro", "bi-cart"),
        new("Estoque crítico", 7, "quantidade", "critico", "bi-box"),
        new("Títulos vencidos", 4, "moeda", "negativo", "bi-cash"),
        new("Outbox com erro", 1, "quantidade", "negativo", "bi-send-exclamation")
    ];

    private IReadOnlyList<DashboardChartResponse> Charts =>
    [
        new("Pedidos por status", "barras", ["Aberto", "Fluxo", "Faturado", "Cancelado"], [18, 9, 14, 1]),
        new("Tarefas por status", "barras", ["Backlog", "Andamento", "Validação", "Concluído"], [8, 5, 3, 21]),
        new("Faturamento mensal", "linha", ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun"], [12000, 18000, 21000, 26000, 32000, 39000])
    ];

    public Task AggregateAsync(CancellationToken ct)
    {
        logger.LogInformation("Agregando KPIs, snapshots, alertas e métricas Project da Sprint 7.");
        return Task.CompletedTask;
    }

    public Task<IReadOnlyList<KpiValueResponse>> CalculateAllAsync(Guid tenantId, CancellationToken ct)
        => Task.FromResult<IReadOnlyList<KpiValueResponse>>(ListKpiSeeds().Select(x => new KpiValueResponse(Guid.NewGuid(), x.Id, 85, "positivo", DateTimeOffset.UtcNow)).ToArray());

    public Task<OperationalScoreResponse> RecalculateAsync(Guid tenantId, CancellationToken ct) => ScoreAsync(tenantId, ct);
    public Task<OperationalScoreResponse> ScoreAsync(Guid tenantId, CancellationToken ct) => Task.FromResult(new OperationalScoreResponse(82, "neutro", new Dictionary<string, decimal> { ["tarefas_atrasadas"] = 3, ["project_conclusao"] = 72 }, DateTimeOffset.UtcNow));
    public async Task<ExecutiveDashboardResponse> ExecutiveAsync(Guid tenantId, CancellationToken ct) => new(await ScoreAsync(tenantId, ct), Cards, Charts, ["Separação logística", "Emissão fiscal"], await AlertsAsync(tenantId, ct));
    public Task<FlowBiDashboardResponse> FlowAsync(Guid tenantId, CancellationToken ct) => Task.FromResult(new FlowBiDashboardResponse(Cards.Take(2).ToArray(), Charts.Take(1).ToArray()));
    public Task<CommercialBiDashboardResponse> CommercialAsync(Guid tenantId, CancellationToken ct) => Task.FromResult(new CommercialBiDashboardResponse(Cards.Skip(2).Take(1).ToArray(), Charts.Take(1).ToArray()));
    public Task<InventoryBiDashboardResponse> InventoryAsync(Guid tenantId, CancellationToken ct) => Task.FromResult(new InventoryBiDashboardResponse(Cards.Skip(3).Take(1).ToArray(), Charts.Skip(1).Take(1).ToArray()));
    public Task<BillingBiDashboardResponse> BillingAsync(Guid tenantId, CancellationToken ct) => Task.FromResult(new BillingBiDashboardResponse(Cards.Skip(4).Take(1).ToArray(), Charts.Skip(2).Take(1).ToArray()));
    public Task<ConnectBiDashboardResponse> ConnectAsync(Guid tenantId, CancellationToken ct) => Task.FromResult(new ConnectBiDashboardResponse(Cards.Skip(5).Take(1).ToArray(), Charts.Take(1).ToArray()));

    public Task<IReadOnlyList<KpiDefinitionResponse>> ListKpisAsync(Guid tenantId, CancellationToken ct) => Task.FromResult<IReadOnlyList<KpiDefinitionResponse>>(ListKpiSeeds());
    public Task<KpiDefinitionResponse> CreateKpiAsync(Guid tenantId, CreateKpiDefinitionRequest request, CancellationToken ct) { var item = new KpiDefinitionResponse(Guid.NewGuid(), tenantId, request.Codigo, request.Nome, request.Modulo, request.Unidade, "ativo"); _kpis.Add(item); return Task.FromResult(item); }
    public Task<KpiDefinitionResponse> UpdateKpiAsync(Guid tenantId, Guid id, UpdateKpiDefinitionRequest request, CancellationToken ct) => Task.FromResult(new KpiDefinitionResponse(id, tenantId, "custom", request.Nome, request.Modulo, request.Unidade, request.Ativo ? "ativo" : "inativo"));
    public Task<KpiTargetResponse> SetTargetAsync(Guid tenantId, Guid id, SetKpiTargetRequest request, CancellationToken ct) => Task.FromResult(new KpiTargetResponse(Guid.NewGuid(), id, request.ValorMeta));
    public Task<IReadOnlyList<KpiAlertResponse>> AlertsAsync(Guid tenantId, CancellationToken ct) => Task.FromResult<IReadOnlyList<KpiAlertResponse>>([new(Guid.NewGuid(), "outbox_com_erro", "Outbox possui mensagens com erro.", "critico", DateTimeOffset.UtcNow)]);

    public Task<IReadOnlyList<ProjectBoardResponse>> ListBoardsAsync(Guid tenantId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectBoardResponse>>([DemoBoard()]);
    public async Task<ProjectBoardDetailResponse> GetBoardAsync(Guid tenantId, Guid boardId, CancellationToken ct) => new(boardId, "Board Demo IntegraRP", "Sprints S1 a S7", "ativo", await ListSprintsAsync(tenantId, boardId, ct), DemoBoard().Colunas, await MetricsAsync(tenantId, boardId, ct));
    public Task<ProjectBoardResponse> CreateBoardAsync(Guid tenantId, CreateProjectBoardRequest request, CancellationToken ct) { var board = new ProjectBoardResponse(Guid.NewGuid(), request.Nome, request.Descricao ?? string.Empty, "ativo", request.CriarColunasPadrao ? DefaultColumns(Guid.NewGuid()) : []); _boards.Add(board); AddFeed("board.criado", $"Board {request.Nome} criado"); return Task.FromResult(board); }
    public Task<ProjectBoardResponse> UpdateBoardAsync(Guid tenantId, Guid boardId, UpdateProjectBoardRequest request, CancellationToken ct) { AddFeed("board.editado", $"Board {request.Nome} editado"); return Task.FromResult(new ProjectBoardResponse(boardId, request.Nome, request.Descricao ?? string.Empty, request.Status, DefaultColumns(boardId))); }
    public Task DeleteBoardAsync(Guid tenantId, Guid boardId, CancellationToken ct) { AddFeed("board.excluido", "Board excluído"); return Task.CompletedTask; }
    public Task<IReadOnlyList<ProjectColumnResponse>> CreateDefaultColumnsAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectColumnResponse>>(DefaultColumns(boardId));
    public Task<IReadOnlyList<ProjectSprintResponse>> ListSprintsAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectSprintResponse>>(Enumerable.Range(1, 7).Select(i => new ProjectSprintResponse(Guid.NewGuid(), boardId, $"S{i}", $"Sprint {i}", new DateOnly(2026, 1, 1).AddDays((i - 1) * 14), new DateOnly(2026, 1, 14).AddDays((i - 1) * 14), i == 7 ? "ativa" : "concluida", 20)).ToArray());
    public Task<ProjectSprintResponse> CreateSprintAsync(Guid tenantId, Guid boardId, CreateProjectSprintRequest request, CancellationToken ct) { AddFeed("sprint.criada", request.Nome); return Task.FromResult(new ProjectSprintResponse(Guid.NewGuid(), boardId, request.Codigo, request.Nome, request.DataInicio, request.DataFim, "planejada", request.MetaPontos)); }
    public Task<ProjectSprintResponse> UpdateSprintAsync(Guid tenantId, Guid id, UpdateProjectSprintRequest request, CancellationToken ct) => Task.FromResult(new ProjectSprintResponse(id, Guid.NewGuid(), "S", request.Nome, request.DataInicio, request.DataFim, request.Status, request.MetaPontos));
    public Task<ProjectSprintResponse> ActivateSprintAsync(Guid tenantId, Guid id, CancellationToken ct) => Task.FromResult(new ProjectSprintResponse(id, Guid.NewGuid(), "S", "Sprint ativa", DateOnly.FromDateTime(DateTime.UtcNow), DateOnly.FromDateTime(DateTime.UtcNow.AddDays(14)), "ativa", 20));
    public Task<ProjectSprintResponse> CloseSprintAsync(Guid tenantId, Guid id, CancellationToken ct) => Task.FromResult(new ProjectSprintResponse(id, Guid.NewGuid(), "S", "Sprint concluída", DateOnly.FromDateTime(DateTime.UtcNow), DateOnly.FromDateTime(DateTime.UtcNow.AddDays(14)), "concluida", 20));
    public Task<IReadOnlyList<ProjectColumnResponse>> ListColumnsAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectColumnResponse>>(DefaultColumns(boardId));
    public Task<ProjectColumnResponse> CreateColumnAsync(Guid tenantId, Guid boardId, CreateProjectColumnRequest request, CancellationToken ct) => Task.FromResult(new ProjectColumnResponse(Guid.NewGuid(), boardId, request.Nome, request.Ordem, request.EhConclusiva, []));
    public Task<ProjectColumnResponse> UpdateColumnAsync(Guid tenantId, Guid id, UpdateProjectColumnRequest request, CancellationToken ct) => Task.FromResult(new ProjectColumnResponse(id, Guid.NewGuid(), request.Nome, request.Ordem, request.EhConclusiva, []));
    public Task<ProjectColumnResponse> MoveColumnAsync(Guid tenantId, Guid id, MoveProjectColumnRequest request, CancellationToken ct) => Task.FromResult(new ProjectColumnResponse(id, Guid.NewGuid(), "Coluna movida", request.Ordem, false, []));
    public Task DeleteColumnAsync(Guid tenantId, Guid id, CancellationToken ct) => Task.CompletedTask;
    public Task<IReadOnlyList<ProjectItemResponse>> ListItemsAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectItemResponse>>(DefaultColumns(boardId).SelectMany(x => x.Itens).ToArray());
    public Task<ProjectItemDetailResponse> GetItemAsync(Guid tenantId, Guid id, CancellationToken ct) => Task.FromResult(new ProjectItemDetailResponse(new ProjectItemResponse(id, Guid.NewGuid(), Guid.NewGuid(), null, "S7-1", "BI/KPIs + Project base", "alta", 13, "Admin", DateOnly.FromDateTime(DateTime.UtcNow.AddDays(5)), null), []));
    public Task<ProjectItemResponse> CreateItemAsync(Guid tenantId, Guid boardId, CreateProjectItemRequest request, CancellationToken ct) { var col = request.ColunaId ?? Guid.NewGuid(); AddFeed("item.criado", request.Titulo); return Task.FromResult(new ProjectItemResponse(Guid.NewGuid(), boardId, col, request.SprintId, "S7-NEW", request.Titulo, request.Prioridade, request.StoryPoints, request.ResponsavelNome, request.DataLimite, null)); }
    public Task<ProjectItemResponse> UpdateItemAsync(Guid tenantId, Guid id, UpdateProjectItemRequest request, CancellationToken ct) => Task.FromResult(new ProjectItemResponse(id, Guid.NewGuid(), Guid.NewGuid(), null, "S7-UPD", request.Titulo, request.Prioridade, request.StoryPoints, request.ResponsavelNome, request.DataLimite, null));
    public Task<ProjectItemResponse> MoveItemAsync(Guid tenantId, Guid id, MoveProjectItemRequest request, CancellationToken ct) { AddFeed("item.movido", "Item movido entre colunas"); return Task.FromResult(new ProjectItemResponse(id, Guid.NewGuid(), request.ColunaId, null, "S7-MOV", "Item movido", "media", 5, "Admin", null, DateTimeOffset.UtcNow)); }
    public Task DeleteItemAsync(Guid tenantId, Guid id, CancellationToken ct) { AddFeed("item.excluido", "Item excluído com soft delete"); return Task.CompletedTask; }
    public Task<ProjectItemCommentResponse> AddCommentAsync(Guid tenantId, Guid id, AddProjectItemCommentRequest request, CancellationToken ct) { AddFeed("comentario.criado", request.Mensagem); return Task.FromResult(new ProjectItemCommentResponse(Guid.NewGuid(), id, request.Mensagem, "Admin", DateTimeOffset.UtcNow)); }
    public Task<ProjectItemCommentResponse> AddAttachmentAsync(Guid tenantId, Guid id, AddProjectItemCommentRequest request, CancellationToken ct) => AddCommentAsync(tenantId, id, request, ct);
    public Task<ProjectMetricsResponse> MetricsAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult(new ProjectMetricsResponse(7, 6, 1, 89, 76, 85.39m));
    public Task<IReadOnlyList<ProjectFeedEventResponse>> FeedAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectFeedEventResponse>>(_feed.Count == 0 ? [new(Guid.NewGuid(), "board.importado", "Board demo carregado", DateTimeOffset.UtcNow)] : _feed.ToArray());
    public Task<IReadOnlyList<ProjectVelocityResponse>> VelocityAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectVelocityResponse>>([new("S1", 8), new("S2", 13), new("S3", 21), new("S4", 13), new("S5", 8), new("S6", 13), new("S7", 5)]);
    public Task<IReadOnlyList<ProjectBurndownResponse>> BurndownAsync(Guid tenantId, Guid boardId, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProjectBurndownResponse>>([new(DateOnly.FromDateTime(DateTime.UtcNow), 34), new(DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)), 21), new(DateOnly.FromDateTime(DateTime.UtcNow.AddDays(2)), 13)]);
    public async Task<ProjectExportResponse> ExportAsync(Guid tenantId, Guid boardId, CancellationToken ct) => new(boardId, "Board Demo IntegraRP", JsonSerializer.Serialize(await GetBoardAsync(tenantId, boardId, ct)), DateTimeOffset.UtcNow);
    public Task<ProjectImportResponse> ImportAsync(Guid tenantId, Guid boardId, ProjectImportRequest request, CancellationToken ct) { AddFeed("board.importado", "Board importado por JSON"); return Task.FromResult(new ProjectImportResponse(boardId, 7, "importado")); }

    private IReadOnlyList<KpiDefinitionResponse> ListKpiSeeds() => _kpis.Concat(Enumerable.Range(1, 16).Select(i => new KpiDefinitionResponse(Guid.NewGuid(), null, $"s7_{i}", $"KPI Sprint 7 {i}", "Sprint7", "quantidade", "ativo"))).ToArray();
    private ProjectBoardResponse DemoBoard() { var id = Guid.Parse("22222222-2222-2222-2222-222222222222"); return new ProjectBoardResponse(id, "Board Demo IntegraRP", "Sprints S1 a S7", "ativo", DefaultColumns(id)); }
    private static IReadOnlyList<ProjectColumnResponse> DefaultColumns(Guid boardId) { var cols = new[] { "Backlog", "A Fazer", "Em Andamento", "Em Validação", "Concluído" }; return cols.Select((n, i) => new ProjectColumnResponse(Guid.NewGuid(), boardId, n, i + 1, i == 4, i == 4 ? [new ProjectItemResponse(Guid.NewGuid(), boardId, Guid.NewGuid(), null, $"S{i + 1}", "Fundação e arquitetura", "alta", 13, "IntegraRP", null, DateTimeOffset.UtcNow)] : [])).ToArray(); }
    private void AddFeed(string tipo, string descricao) => _feed.Add(new ProjectFeedEventResponse(Guid.NewGuid(), tipo, descricao, DateTimeOffset.UtcNow));
}
