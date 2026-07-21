namespace IntegraRP.Web.Models.Navigation;

public sealed record NavigationItem(string Text, string Icon, string Controller, string Action = "Index", string? Area = null, string? RequiredPolicy = null, NavigationBadge? Badge = null, bool IsFavorite = false)
{
    public string Url => string.IsNullOrWhiteSpace(Area) ? $"/{Controller.ToLowerInvariant()}" : $"/{Area}/{Controller.ToLowerInvariant()}";
}
