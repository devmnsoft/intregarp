namespace IntegraRP.Web.ViewModels.Dashboard;

public sealed class DashboardViewModel
{
    public string TenantName { get; init; } = "Matriz";
    public DateTimeOffset LastUpdatedAt { get; init; } = DateTimeOffset.UtcNow;
    public IReadOnlyList<KpiCardViewModel> Kpis { get; init; } = Array.Empty<KpiCardViewModel>();
}

public sealed record KpiCardViewModel(string Title, string Value, string Context, string Status, string Icon, string DetailUrl);
