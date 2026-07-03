namespace IntegraRP.Domain.Studio;

public sealed class DynamicField
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public Guid TenantId { get; init; }
    public string Name { get; private set; }
    public string Code { get; private set; }
    public string Label { get; private set; }
    public DynamicFieldType Type { get; private set; }
    public bool Required { get; private set; }
    public bool VisibleOnForm { get; private set; }
    public bool SensitiveLgpd { get; private set; }
    public bool Mask { get; private set; }

    public DynamicField(Guid tenantId, string name, string code, string label, DynamicFieldType type, bool required, bool visibleOnForm, bool sensitiveLgpd = false, bool mask = false, IReadOnlyCollection<string>? options = null, string? relationTarget = null)
    {
        if (string.IsNullOrWhiteSpace(code)) throw new ArgumentException("Código do campo é obrigatório.", nameof(code));
        if (string.IsNullOrWhiteSpace(label)) throw new ArgumentException("Label do campo é obrigatório.", nameof(label));
        if (required && !visibleOnForm) throw new InvalidOperationException("Campo obrigatório não pode ficar invisível no formulário.");
        if (type is DynamicFieldType.Select or DynamicFieldType.MultiSelect && (options is null || options.Count == 0)) throw new InvalidOperationException("Campo select/multiselect precisa de opções.");
        if (type == DynamicFieldType.Relation && string.IsNullOrWhiteSpace(relationTarget)) throw new InvalidOperationException("Campo relation precisa de destino.");
        if (sensitiveLgpd && !mask) throw new InvalidOperationException("Campo sensível LGPD exige mascaramento.");
        TenantId = tenantId;
        Name = name;
        Code = code;
        Label = label;
        Type = type;
        Required = required;
        VisibleOnForm = visibleOnForm;
        SensitiveLgpd = sensitiveLgpd;
        Mask = mask;
    }
}
