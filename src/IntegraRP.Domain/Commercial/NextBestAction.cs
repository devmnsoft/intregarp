namespace IntegraRP.Domain.Commercial;

public sealed record NextBestAction(string Type, string Context, string Priority, DateTimeOffset? DueAt, Guid? AssigneeId, string Recommendation, string DeepLink)
{
    public NextBestAction Validate()
    {
        if (string.IsNullOrWhiteSpace(Type) || string.IsNullOrWhiteSpace(Context) || string.IsNullOrWhiteSpace(Recommendation))
            throw new ArgumentException("Tipo, contexto e recomendação são obrigatórios.");
        if (!DeepLink.StartsWith('/', StringComparison.Ordinal) || DeepLink.StartsWith("//", StringComparison.Ordinal))
            throw new ArgumentException("O destino deve ser uma rota interna válida.");
        return this;
    }
}
