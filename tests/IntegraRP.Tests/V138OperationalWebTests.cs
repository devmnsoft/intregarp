using IntegraRP.Contracts.Onboarding;
using IntegraRP.Domain.Commercial;
using IntegraRP.Web.ViewModels.Onboarding;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V138OperationalWebTests
{
    [Fact]
    public void Onboarding_view_model_uses_backend_percentage_and_supported_routes()
    {
        var state = new OnboardingStateDto(3, [1, 2], false, false, 25, DateTimeOffset.UtcNow, 7);
        var model = OnboardingPageViewModel.From(state);
        Assert.Equal(25, model.Percentage);
        Assert.Equal(8, model.Steps.Count);
        Assert.All(model.Steps, step => Assert.StartsWith("/onboarding/", step.Route));
        Assert.Equal("Concluída", model.Steps[0].Status);
        Assert.Equal("Pendente", model.Steps[2].Status);
    }

    [Fact]
    public void Outbox_retry_policy_is_bounded_and_enters_dead_letter()
    {
        var policy = new OutboxRetryPolicy(5, TimeSpan.FromSeconds(10), TimeSpan.FromMinutes(5));
        Assert.Equal(TimeSpan.FromSeconds(10), policy.NextDelay(0));
        Assert.Equal(TimeSpan.FromMinutes(5), policy.NextDelay(20));
        Assert.True(policy.IsDeadLetter(5));
        Assert.False(policy.IsDeadLetter(4));
    }

    [Fact]
    public void Bootstrap_assets_are_official_complete_distributions()
    {
        var root = FindRepositoryRoot();
        var css = File.ReadAllText(Path.Combine(root, "src/IntegraRP.Web/wwwroot/lib/bootstrap/css/bootstrap.min.css"));
        var bundle = File.ReadAllText(Path.Combine(root, "src/IntegraRP.Web/wwwroot/lib/bootstrap/js/bootstrap.bundle.min.js"));
        var icons = File.ReadAllText(Path.Combine(root, "src/IntegraRP.Web/wwwroot/icons/integrarp-icons.svg"));
        Assert.Contains("Bootstrap v5", css);
        Assert.Contains("Modal", bundle);
        Assert.Contains("id=\"icon-customers\"", icons);
        Assert.True(css.Length > 100_000);
        Assert.True(bundle.Length > 50_000);
    }

    private static string FindRepositoryRoot()
    {
        var directory = new DirectoryInfo(AppContext.BaseDirectory);
        while (directory is not null && !File.Exists(Path.Combine(directory.FullName, "IntegraRP.sln"))) directory = directory.Parent;
        return directory?.FullName ?? throw new DirectoryNotFoundException("Raiz do repositório não encontrada.");
    }
}
