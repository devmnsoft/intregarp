namespace IntegraRP.Api.Security;

public static class ApiPermissions
{
    public const string ClaimType = "permission";
    public static readonly string[] All =
    [
        "customers.view", "customers.create", "customers.update", "customers.delete",
        "products.view", "products.manage", "inventory.view", "inventory.move",
        "orders.view", "orders.create", "orders.confirm", "orders.cancel",
        "tasks.view", "tasks.claim", "tasks.transfer", "tasks.complete",
        "opportunities.view", "opportunities.create", "opportunities.update", "opportunities.delete",
        "activities.view", "activities.create", "activities.update", "activities.delete",
        "quotes.view", "quotes.create", "quotes.update", "quotes.submit", "quotes.cancel",
        "quote-approvals.view", "quote-approvals.decide", "price-lists.view", "price-lists.manage",
        "deliveries.view", "deliveries.manage", "operational-templates.view", "operational-templates.manage",
        "document-templates.view", "document-templates.manage", "documents.view", "documents.generate",
        "dashboard.view", "actions.view", "notifications.view", "audit.view",
        "billing.view", "billing.manage", "reports.view", "dashboard.executive"
    ];
}
