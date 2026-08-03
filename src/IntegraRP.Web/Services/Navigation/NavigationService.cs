using IntegraRP.Web.Models.Navigation;

namespace IntegraRP.Web.Services.Navigation;

public sealed class NavigationService : INavigationService
{
    public IReadOnlyList<NavigationGroup> GetNavigation(System.Security.Claims.ClaimsPrincipal user, string? environmentName)
    {
        var canSeeTechnical = string.Equals(environmentName, "Development", StringComparison.OrdinalIgnoreCase) || user.IsInRole("Tecnico") || user.IsInRole("Administrador");
        var groups = new List<NavigationGroup>
        {
            new("Início", new[] { Item("Visão geral", "dashboard", "Dashboard"), Item("Central de Ações", "action-center", "Journey"), Item("Atividade recente", "activities", "Activities") }),
            new("Operação", new[] { Item("Minhas tarefas", "tasks", "Tasks", "My"), Item("Clientes", "customers", "Customers"), Item("Produtos", "products", "Products"), Item("Estoque", "inventory", "Inventory"), Item("Pedidos", "orders", "Orders"), Item("Logística", "stock-transfer", "Operational"), Item("Entregas", "processes", "Operational") }),
            new("Processos", new[] { Item("Integra Flow", "workflow", "Flow"), Item("Designer de Processos", "processes", "FlowDesigner"), Item("Templates", "categories", "Templates"), Item("Automações", "activities", "Automation") }),
            new("Gestão", new[] { Item("Financeiro", "billing", "Billing"), Item("BI e Indicadores", "dashboard", "Bi"), Item("KPIs", "timeline", "Bi", "Kpis"), Item("Project Central", "tasks", "Project") }),
            new("Plataforma", new[] { Item("Integra Studio", "categories", "Studio"), Item("Integra AI", "help", "Ai"), Item("Connect", "notifications", "Connect") }),
            new("Administração", new[] { Item("Usuários", "users", "Users"), Item("Setores", "sectors", "Departments"), Item("Perfis e Permissões", "roles", "Roles"), Item("Auditoria", "audit", "Audit"), Item("Configurações", "settings", "Settings") })
        };
        if (user.IsInRole("SuperAdmin"))
        {
            groups.Insert(1, new("Super Administração", new[]
            {
                Item("Visão global", "dashboard", "SuperAdmin"),
                Item("Tenants", "tenants", "SuperAdmin"),
                Item("Usuários globais", "users", "SuperAdmin"),
                Item("Saúde do sistema", "health", "SuperAdmin"),
                Item("Auditoria global", "audit", "SuperAdmin")
            }));
        }
        if (canSeeTechnical) groups.Add(new("Técnico", new[] { Item("Homologação", "success", "Homologation"), Item("Diagnóstico", "warning", "Demo") }));
        return groups;
    }

    private static NavigationItem Item(string text, string icon, string controller, string action = "Index", NavigationBadge? badge = null) => new(text, icon, controller, action, Badge: badge);
}
