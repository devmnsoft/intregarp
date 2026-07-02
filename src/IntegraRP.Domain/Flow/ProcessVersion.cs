namespace IntegraRP.Domain.Flow;

public sealed class ProcessVersion
{
    private readonly List<ProcessElement> elements = [];
    private readonly List<ProcessTransition> transitions = [];
    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public Guid ProcessDefinitionId { get; init; }
    public int Number { get; init; } = 1;
    public ProcessVersionStatus Status { get; private set; } = ProcessVersionStatus.Rascunho;
    public IReadOnlyList<ProcessElement> Elements => elements;
    public IReadOnlyList<ProcessTransition> Transitions => transitions;
    public void EnsureMutable() { if (Status == ProcessVersionStatus.Publicada) throw new InvalidOperationException("Versão publicada não pode ser alterada."); }
    public void AddElement(ProcessElement element) { EnsureMutable(); elements.Add(element); }
    public void AddTransition(ProcessTransition transition) { EnsureMutable(); if (transition.ProcessVersionId != Id) throw new InvalidOperationException("Transição precisa pertencer à mesma versão."); transitions.Add(transition); }
    public void Publish() { if (elements.Count(x => x.Type == ProcessElementType.StartEvent) != 1) throw new InvalidOperationException("Versão publicada precisa ter exatamente um StartEvent."); if (!elements.Any(x => x.Type == ProcessElementType.EndEvent)) throw new InvalidOperationException("Versão publicada precisa ter pelo menos um EndEvent."); Status = ProcessVersionStatus.Publicada; }
}
