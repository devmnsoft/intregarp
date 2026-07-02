namespace IntegraRP.Domain.Project;

public enum ProjectBoardStatus { Ativo, Arquivado }
public enum ProjectSprintStatus { Planejada, Ativa, Concluida, Cancelada }
public enum ProjectItemType { Tarefa, Bug, Melhoria, Historia, Epico, Documentacao, Teste }
public enum ProjectItemPriority { Baixa, Media, Alta, Critica }
public enum ProjectFeedEventType { BoardCriado, BoardEditado, SprintCriada, SprintAtivada, SprintConcluida, ColunaCriada, ColunaEditada, ColunaMovida, ColunaExcluida, ItemCriado, ItemEditado, ItemMovido, ItemConcluido, ItemReaberto, ItemExcluido, ComentarioCriado, AnexoCriado, BoardExportado, BoardImportado }

public readonly record struct ProjectItemCode
{
    public ProjectItemCode(string value) => Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Código do item é obrigatório.", nameof(value)) : value.Trim();
    public string Value { get; }
}

public readonly record struct StoryPoints
{
    public StoryPoints(int value) => Value = value < 0 ? throw new ArgumentException("Story points não podem ser negativos.", nameof(value)) : value;
    public int Value { get; }
}

public readonly record struct ProjectColumnOrder(decimal Value);
public readonly record struct HexColor
{
    public HexColor(string value) => Value = string.IsNullOrWhiteSpace(value) ? "#2563EB" : value;
    public string Value { get; }
}

public sealed class ProjectBoard
{
    public ProjectBoard(Guid id, Guid tenantId, string nome)
    {
        if (tenantId == Guid.Empty) throw new ArgumentException("Tenant é obrigatório.", nameof(tenantId));
        Id = id == Guid.Empty ? Guid.NewGuid() : id;
        TenantId = tenantId;
        Nome = string.IsNullOrWhiteSpace(nome) ? throw new ArgumentException("Nome do board é obrigatório.", nameof(nome)) : nome.Trim();
    }

    public Guid Id { get; }
    public Guid TenantId { get; }
    public string Nome { get; }
    public DateTimeOffset? ExcluidoEm { get; private set; }
    public bool PodeReceberItem => ExcluidoEm is null;
    public void Excluir() => ExcluidoEm = DateTimeOffset.UtcNow;
}

public sealed class ProjectSprint
{
    public ProjectSprint(Guid id, Guid tenantId, Guid boardId, string codigo, string nome, DateOnly inicio, DateOnly fim)
    {
        if (fim < inicio) throw new ArgumentException("Data final não pode ser menor que a inicial.", nameof(fim));
        Id = id == Guid.Empty ? Guid.NewGuid() : id; TenantId = tenantId; BoardId = boardId; Codigo = codigo; Nome = nome; DataInicio = inicio; DataFim = fim;
    }
    public Guid Id { get; } public Guid TenantId { get; } public Guid BoardId { get; } public string Codigo { get; } public string Nome { get; } public DateOnly DataInicio { get; } public DateOnly DataFim { get; }
}

public sealed record ProjectColumn(Guid Id, Guid TenantId, Guid BoardId, string Nome, ProjectColumnOrder Ordem, bool EhConclusiva);

public sealed class ProjectItem
{
    public ProjectItem(Guid id, Guid tenantId, Guid boardId, Guid colunaId, string codigo, string titulo, int storyPoints)
    {
        if (colunaId == Guid.Empty) throw new ArgumentException("Coluna é obrigatória.", nameof(colunaId));
        Id = id == Guid.Empty ? Guid.NewGuid() : id; TenantId = tenantId; BoardId = boardId; ColunaId = colunaId; Codigo = new ProjectItemCode(codigo);
        Titulo = string.IsNullOrWhiteSpace(titulo) ? throw new ArgumentException("Título do item é obrigatório.", nameof(titulo)) : titulo.Trim();
        StoryPoints = new StoryPoints(storyPoints);
    }
    public Guid Id { get; } public Guid TenantId { get; } public Guid BoardId { get; } public Guid ColunaId { get; private set; } public ProjectItemCode Codigo { get; } public string Titulo { get; } public StoryPoints StoryPoints { get; } public DateTimeOffset? ConcluidoEm { get; private set; } public DateTimeOffset? ExcluidoEm { get; private set; }
    public ProjectFeedEvent MoveTo(Guid colunaId, bool colunaConclusiva) { ColunaId = colunaId; ConcluidoEm = colunaConclusiva ? DateTimeOffset.UtcNow : null; return new ProjectFeedEvent(Guid.NewGuid(), TenantId, BoardId, Id, ProjectFeedEventType.ItemMovido, "Item movido", DateTimeOffset.UtcNow); }
    public ProjectFeedEvent Excluir() { ExcluidoEm = DateTimeOffset.UtcNow; return new ProjectFeedEvent(Guid.NewGuid(), TenantId, BoardId, Id, ProjectFeedEventType.ItemExcluido, "Item excluído", DateTimeOffset.UtcNow); }
}

public sealed record ProjectItemComment(Guid Id, Guid TenantId, Guid ItemId, string Mensagem, DateTimeOffset CriadoEm);
public sealed record ProjectItemAttachment(Guid Id, Guid TenantId, Guid ItemId, string NomeArquivo, string Url);
public sealed record ProjectFeedEvent(Guid Id, Guid TenantId, Guid BoardId, Guid? ItemId, ProjectFeedEventType Tipo, string Descricao, DateTimeOffset CriadoEm);
public sealed record ProjectImport(Guid Id, Guid TenantId, Guid BoardId, DateTimeOffset CriadoEm);
public sealed record ProjectExport(Guid Id, Guid TenantId, Guid BoardId, DateTimeOffset CriadoEm);
