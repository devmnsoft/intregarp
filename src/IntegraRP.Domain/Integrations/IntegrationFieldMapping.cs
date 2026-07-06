namespace IntegraRP.Domain.Integrations;

public sealed record IntegrationFieldMapping(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
