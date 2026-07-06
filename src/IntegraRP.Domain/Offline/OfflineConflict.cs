namespace IntegraRP.Domain.Offline;

public sealed record OfflineConflict(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
