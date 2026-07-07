namespace IntegraRP.Domain.Journey;

public enum JourneyStatus { Rascunho, Ativa, Inativa }
public enum JourneyStepType { Manual, Navigation, ApiCheck, Checklist, Form, Video, Documentation, Automation }
public enum JourneyStepStatus { Pendente, EmAndamento, Concluida, Ignorada, Bloqueada }
public enum RecommendedActionPriority { Baixa, Media, Alta, Critica }
public enum RecommendedActionStatus { Pendente, Concluida, Ignorada }
public enum EmptyStateType { Lista, Dashboard, Modulo, Busca, Erro }
public enum GuidedTourTriggerType { PrimeiraVisita, Manual, Rota, Perfil, Evento }

public readonly record struct JourneyCode
{
    public JourneyCode(string value) => Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Código da jornada é obrigatório.", nameof(value)) : value.Trim();
    public string Value { get; }
}

public readonly record struct JourneyStepCode
{
    public JourneyStepCode(string value) => Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Código da etapa é obrigatório.", nameof(value)) : value.Trim();
    public string Value { get; }
}

public readonly record struct JourneyProgressPercent
{
    public JourneyProgressPercent(decimal value) => Value = value is < 0 or > 100 ? throw new ArgumentOutOfRangeException(nameof(value), "Progresso deve ficar entre 0 e 100.") : value;
    public decimal Value { get; }
}

public readonly record struct RecommendedActionReason
{
    public RecommendedActionReason(string value) => Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Motivo da ação recomendada é obrigatório.", nameof(value)) : value.Trim();
    public string Value { get; }
}

public sealed class CustomerJourney
{
    private readonly List<JourneyStep> _steps = [];
    public CustomerJourney(Guid id, Guid? tenantId, string code, string name)
    {
        Id = id == Guid.Empty ? Guid.NewGuid() : id;
        TenantId = tenantId;
        Code = new JourneyCode(code);
        Name = string.IsNullOrWhiteSpace(name) ? throw new ArgumentException("Nome da jornada é obrigatório.", nameof(name)) : name.Trim();
    }
    public Guid Id { get; }
    public Guid? TenantId { get; }
    public JourneyCode Code { get; }
    public string Name { get; }
    public IReadOnlyCollection<JourneyStep> Steps => _steps;
    public void AddStep(JourneyStep step) => _steps.Add(step ?? throw new ArgumentNullException(nameof(step)));
    public void EnsureCanPublish() { if (_steps.Count == 0) throw new InvalidOperationException("Jornada precisa ter pelo menos uma etapa."); }
}

public sealed class JourneyStep
{
    public JourneyStep(Guid id, string code, string title, JourneyStepType type, bool required, string completionCriteriaJson = "{}")
    {
        Id = id == Guid.Empty ? Guid.NewGuid() : id;
        Code = new JourneyStepCode(code);
        Title = string.IsNullOrWhiteSpace(title) ? throw new ArgumentException("Título da etapa é obrigatório.", nameof(title)) : title.Trim();
        Type = type;
        Required = required;
        CompletionCriteriaJson = completionCriteriaJson;
        if (Required && string.IsNullOrWhiteSpace(completionCriteriaJson)) throw new InvalidOperationException("Etapa obrigatória deve ter critério de conclusão.");
    }
    public Guid Id { get; }
    public JourneyStepCode Code { get; }
    public string Title { get; }
    public JourneyStepType Type { get; }
    public bool Required { get; }
    public string CompletionCriteriaJson { get; }
}

public sealed class UserJourneyProgress
{
    public UserJourneyProgress(Guid tenantId, Guid userId, Guid journeyId)
    { TenantId = tenantId != Guid.Empty ? tenantId : throw new ArgumentException("Tenant obrigatório.", nameof(tenantId)); UserId = userId != Guid.Empty ? userId : throw new ArgumentException("Usuário obrigatório.", nameof(userId)); JourneyId = journeyId; }
    public Guid TenantId { get; }
    public Guid UserId { get; }
    public Guid JourneyId { get; }
    public JourneyStepStatus Status { get; private set; } = JourneyStepStatus.Pendente;
    public JourneyProgressPercent Progress { get; private set; } = new(0);
    public void Block() => Status = JourneyStepStatus.Bloqueada;
    public void CompleteStep(decimal progress) { if (Status == JourneyStepStatus.Bloqueada) throw new InvalidOperationException("Usuário não pode concluir etapa bloqueada."); Status = JourneyStepStatus.Concluida; Progress = new JourneyProgressPercent(progress); }
    public void Skip() => Status = JourneyStepStatus.Ignorada;
}

public sealed class RecommendedAction
{
    public RecommendedAction(Guid id, Guid tenantId, string title, RecommendedActionReason reason)
    { Id = id == Guid.Empty ? Guid.NewGuid() : id; TenantId = tenantId; Title = string.IsNullOrWhiteSpace(title) ? throw new ArgumentException("Título obrigatório.", nameof(title)) : title.Trim(); Reason = reason; }
    public Guid Id { get; }
    public Guid TenantId { get; }
    public string Title { get; }
    public RecommendedActionReason Reason { get; }
    public RecommendedActionStatus Status { get; private set; } = RecommendedActionStatus.Pendente;
    public void Complete() { if (Status == RecommendedActionStatus.Concluida) throw new InvalidOperationException("Ação recomendada concluída não pode ser concluída novamente."); Status = RecommendedActionStatus.Concluida; }
}

public sealed record JourneyChecklist(Guid Id, Guid TenantId, Guid JourneyStepId, string Title);
public sealed record JourneyChecklistItem(Guid Id, Guid ChecklistId, string Title, bool Required);
public sealed record JourneyEvent(Guid Id, Guid TenantId, Guid UserId, string Type, DateTimeOffset CreatedAt);
public sealed record ContextualTip(Guid Id, Guid? TenantId, string ScreenKey, string Title, string Body, string NextActionLabel);
public sealed record GuidedTour(Guid Id, Guid? TenantId, string Code, string Title);
public sealed record GuidedTourStep(Guid Id, Guid TourId, string TargetSelector, string Title, int Order);
public sealed record UserJourneyFeedback(Guid Id, Guid TenantId, Guid UserId, int Rating, string Comment);
public sealed class EmptyStateGuidance
{
    public EmptyStateGuidance(Guid id, string screenKey, string title, string nextActionLabel)
    { Id = id == Guid.Empty ? Guid.NewGuid() : id; ScreenKey = screenKey; Title = title; NextActionLabel = string.IsNullOrWhiteSpace(nextActionLabel) ? throw new InvalidOperationException("Estado vazio deve sempre ter uma próxima ação clara.") : nextActionLabel; }
    public Guid Id { get; }
    public string ScreenKey { get; }
    public string Title { get; }
    public string NextActionLabel { get; }
}
