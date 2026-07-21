namespace IntegraRP.Web.Models.Navigation;

public sealed record NavigationGroup(string Title, IReadOnlyList<NavigationItem> Items);
