namespace IntegraRP.Domain.Integrations;

public sealed record IntegrationConnector(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
