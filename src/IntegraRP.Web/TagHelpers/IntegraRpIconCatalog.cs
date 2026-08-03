namespace IntegraRP.Web.TagHelpers;

public static class IntegraRpIconCatalog
{
    public static readonly IReadOnlySet<string> Names = new HashSet<string>(StringComparer.Ordinal)
    {
        "dashboard", "my-day", "action-center", "customers", "contacts", "opportunities", "activities", "quotes", "approvals", "orders",
        "products", "categories", "inventory", "stock-entry", "stock-exit", "stock-transfer", "reservations", "tasks", "workflow", "processes",
        "billing", "notifications", "search", "settings", "users", "sectors", "roles", "audit", "help", "create", "edit", "delete", "view",
        "download", "upload", "print", "filter", "sort", "calendar", "timeline", "warning", "error", "success", "pending", "menu",
        "tenants", "health", "close"
    };
}
