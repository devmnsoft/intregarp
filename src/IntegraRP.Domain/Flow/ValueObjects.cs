namespace IntegraRP.Domain.Flow;

public readonly record struct ProcessCode
{
    public ProcessCode(string value) { if (string.IsNullOrWhiteSpace(value)) throw new ArgumentException("Código do processo é obrigatório."); Value = value.Trim(); }
    public string Value { get; }
}

public readonly record struct TaskCode
{
    public TaskCode(string value) { if (string.IsNullOrWhiteSpace(value)) throw new ArgumentException("Código da tarefa é obrigatório."); Value = value.Trim(); }
    public string Value { get; }
}

public readonly record struct ProcessVersionNumber
{
    public ProcessVersionNumber(int value) { if (value <= 0) throw new ArgumentOutOfRangeException(nameof(value)); Value = value; }
    public int Value { get; }
}

public readonly record struct SlaMinutes
{
    public SlaMinutes(int value) { if (value <= 0) throw new ArgumentOutOfRangeException(nameof(value)); Value = value; }
    public int Value { get; }
}

public readonly record struct WorkflowVariableName
{
    public WorkflowVariableName(string value) { if (string.IsNullOrWhiteSpace(value)) throw new ArgumentException("Nome da variável é obrigatório."); Value = value.Trim(); }
    public string Value { get; }
}
