namespace IntegraRP.Domain.Studio;

public sealed class DynamicModule
{
    private readonly List<DynamicEntity> entities = [];
    private readonly List<DynamicField> fields = [];
    private readonly List<DynamicAction> actions = [];
    private readonly List<string> semanticScopes = [];

    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public string Name { get; private set; }
    public string Code { get; private set; }
    public string Slug { get; private set; }
    public DynamicModuleStatus Status { get; private set; } = DynamicModuleStatus.Draft;
    public bool AllowsAi { get; private set; }
    public IReadOnlyCollection<DynamicEntity> Entities => entities;
    public IReadOnlyCollection<DynamicField> Fields => fields;
    public IReadOnlyCollection<DynamicAction> Actions => actions;

    public DynamicModule(Guid tenantId, string name, string code, string slug, bool allowsAi = false)
    {
        if (tenantId == Guid.Empty) throw new ArgumentException("Tenant obrigatório.", nameof(tenantId));
        if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException("Nome do módulo é obrigatório.", nameof(name));
        if (string.IsNullOrWhiteSpace(code)) throw new ArgumentException("Código do módulo é obrigatório.", nameof(code));
        if (string.IsNullOrWhiteSpace(slug)) throw new ArgumentException("Slug do módulo é obrigatório.", nameof(slug));
        TenantId = tenantId;
        Name = name.Trim();
        Code = code.Trim();
        Slug = slug.Trim();
        AllowsAi = allowsAi;
    }

    public void AddEntity(DynamicEntity entity) => entities.Add(entity);
    public void AddField(DynamicField field) => fields.Add(field);
    public void AddAction(DynamicAction action) => actions.Add(action);
    public void RegisterSemanticScope(string scope) { if (!string.IsNullOrWhiteSpace(scope)) semanticScopes.Add(scope); }

    public void Publish()
    {
        if (!entities.Any(x => x.IsMain)) throw new InvalidOperationException("Módulo precisa ter entidade principal para publicação.");
        if (!fields.Any(x => x.VisibleOnForm)) throw new InvalidOperationException("Módulo publicado precisa ter campo visível no formulário.");
        if (!actions.Any(x => x.Type is DynamicActionType.Open or DynamicActionType.Create or DynamicActionType.Edit)) throw new InvalidOperationException("Módulo publicado precisa ter ação de abertura ou detalhe.");
        if (AllowsAi && semanticScopes.Count == 0) throw new InvalidOperationException("Módulo com IA precisa de catálogo semântico.");
        Status = DynamicModuleStatus.Published;
    }
}
