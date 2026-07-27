using IntegraRP.Application.Commercial;
using IntegraRP.Domain.Commercial;
using System.Text.Json;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V132CommercialPoliciesTests
{
    [Theory]
    [InlineData("529.982.247-25")]
    [InlineData("04.252.011/0001-10")]
    public void Documento_Brasileiro_Valido_Passa_Digitos_Verificadores(string document)
        => Assert.True(CustomerPolicy.IsValidBrazilianDocument(document));

    [Theory]
    [InlineData("111.111.111-11")]
    [InlineData("04.252.011/0001-11")]
    [InlineData("123")]
    public void Documento_Brasileiro_Invalido_E_Rejeitado(string document)
        => Assert.False(CustomerPolicy.IsValidBrazilianDocument(document));

    [Fact]
    public void Pedido_Nao_Pula_Estado_Confirmado()
    {
        Assert.True(OrderStateMachine.CanTransition(OrderStateMachine.Draft, OrderStateMachine.Confirmed));
        Assert.False(OrderStateMachine.CanTransition(OrderStateMachine.Draft, OrderStateMachine.Picking));
        Assert.True(OrderStateMachine.CanTransition(OrderStateMachine.BillingPending, OrderStateMachine.Billed));
    }

    [Fact]
    public void Auditoria_Mascara_Json_Recursivamente_Sem_Corromper_Chaves_Nao_Sensiveis()
    {
        var masked = new AuditService().MaskSensitive("""{"password":"p","customer":{"email":"a@b.com","name":"Ana"},"items":[{"token":"t"}]}""");
        using var json = JsonDocument.Parse(masked);
        Assert.Equal("***", json.RootElement.GetProperty("password").GetString());
        Assert.Equal("***", json.RootElement.GetProperty("customer").GetProperty("email").GetString());
        Assert.Equal("Ana", json.RootElement.GetProperty("customer").GetProperty("name").GetString());
        Assert.Equal("***", json.RootElement.GetProperty("items")[0].GetProperty("token").GetString());
    }
}
