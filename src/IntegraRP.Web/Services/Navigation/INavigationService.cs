using IntegraRP.Web.Models.Navigation;

namespace IntegraRP.Web.Services.Navigation;

public interface INavigationService
{
    IReadOnlyList<NavigationGroup> GetNavigation(System.Security.Claims.ClaimsPrincipal user, string? environmentName);
}
