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
        "billing.view", "billing.manage", "reports.view", "dashboard.executive"
    ];
}
