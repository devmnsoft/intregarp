namespace IntegraRP.Domain.Routing;

public sealed record RouteOptimizationResult(Guid Id, Guid TenantId, string Status, DateTimeOffset CriadoEm)
{
    public Dictionary<string, object?> Metadata { get; init; } = new();
}
