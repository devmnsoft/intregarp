using IntegraRP.Domain.Commercial;
using IntegraRP.Contracts.Commercial;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V137ProductJourneyTests
{
    [Theory]
    [InlineData("/orders/1")]
    [InlineData("/tasks/my/1")]
    [InlineData("/")]
    public void NextBestActionAcceptsNavigableInternalDeepLink(string deepLink)
    {
        var action = new NextBestAction("tarefa_vencida", "Pedido PED-2026-000001", "alta", DateTimeOffset.UtcNow, null, "Assumir a separação", deepLink);
        Assert.Same(action, action.Validate());
    }

    [Theory]
    [InlineData("http://example.com")]
    [InlineData("https://example.com")]
    [InlineData("//example.com")]
    [InlineData("javascript:alert(1)")]
    [InlineData("")]
    [InlineData("   ")]
    public void NextBestActionRejectsExternalOrEmptyDeepLink(string deepLink)
    {
        var action = new NextBestAction("tarefa", "Pedido", "alta", null, null, "Abrir tarefa", deepLink);
        Assert.Throws<ArgumentException>(() => action.Validate());
    }
}

public sealed class V137NotificationTests
{
    [Fact]
    public void NotificationContractPreservesReadStateAndDeepLink()
    {
        var item = new NotificationDto(Guid.NewGuid(), "tarefa.criada", "Nova separação", "Assuma a tarefa.", "box", "/tasks/my/42", "alta", false, DateTimeOffset.UtcNow, 1);
        Assert.False(item.IsRead);
        Assert.StartsWith("/tasks/my/", item.DeepLink);
    }
}
