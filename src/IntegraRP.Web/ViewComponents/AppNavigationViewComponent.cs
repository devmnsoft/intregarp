using IntegraRP.Web.Services.Navigation;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.ViewComponents;

public sealed class AppNavigationViewComponent(INavigationService navigation, IWebHostEnvironment environment) : ViewComponent
{
    public IViewComponentResult Invoke() => View(navigation.GetNavigation(UserClaimsPrincipal, environment.EnvironmentName));
}
