using IntegraRP.Web.Models.Navigation;

namespace IntegraRP.Web.Services.Navigation;

public sealed class NavigationService : INavigationService
{
    public IReadOnlyList<NavigationGroup> GetNavigation(System.Security.Claims.ClaimsPrincipal user, string? environmentName)
    {
        var canSeeTechnical = string.Equals(environmentName, "Development", StringComparison.OrdinalIgnoreCase) || user.IsInRole("Tecnico") || user.IsInRole("Administrador");
        var groups = new List<NavigationGroup>
        {
            new("Visão geral", new[] { Item("Dashboard", "bi-speedometer2", "Dashboard"), Item("O que fazer agora", "bi-compass", "Journey"), Item("Atividades", "bi-activity", "Activities") }),
            new("Operação", new[] { Item("Minhas tarefas", "bi-check2-square", "Tasks", "My", new NavigationBadge("3", "warning")), Item("Clientes", "bi-people", "Customers"), Item("Produtos", "bi-box-seam", "Products"), Item("Estoque", "bi-boxes", "Inventory"), Item("Pedidos", "bi-receipt", "Orders"), Item("Logística", "bi-truck", "Operational"), Item("Entregas", "bi-geo-alt", "Operational") }),
            new("Processos", new[] { Item("Integra Flow", "bi-diagram-3", "Flow"), Item("Designer de Processos", "bi-bezier2", "FlowDesigner"), Item("Templates", "bi-layers", "Templates"), Item("Automações", "bi-lightning-charge", "Automation") }),
            new("Gestão", new[] { Item("Financeiro", "bi-cash-coin", "Billing"), Item("BI e Indicadores", "bi-graph-up", "Bi"), Item("KPIs", "bi-bar-chart", "Bi", "Kpis"), Item("Project Central", "bi-kanban", "Project") }),
            new("Plataforma", new[] { Item("Integra Studio", "bi-grid-1x2", "Studio"), Item("Integra AI", "bi-stars", "Ai"), Item("Connect", "bi-broadcast", "Connect") }),
            new("Administração", new[] { Item("Usuários", "bi-person-gear", "Users"), Item("Setores", "bi-diagram-2", "Departments"), Item("Perfis e Permissões", "bi-shield-lock", "Roles"), Item("Auditoria", "bi-journal-check", "Audit"), Item("Configurações", "bi-gear", "Settings") })
        };
        if (canSeeTechnical) groups.Add(new("Técnico", new[] { Item("Homologação", "bi-clipboard-check", "Homologation"), Item("Diagnóstico", "bi-bug", "Demo") }));
        return groups;
    }

    private static NavigationItem Item(string text, string icon, string controller, string action = "Index", NavigationBadge? badge = null) => new(text, icon, controller, action, Badge: badge);
}
