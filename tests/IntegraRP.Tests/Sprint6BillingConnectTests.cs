using IntegraRP.Domain.Billing;
using IntegraRP.Domain.Connect;
using Xunit;

namespace IntegraRP.Tests;

public sealed class Sprint6BillingConnectTests
{
    [Fact]
    public void Migration_0006_Deve_Existir_E_Usar_Apenas_Schema_Integrarp()
    {
        var path = Path.Combine("..", "..", "..", "..", "database", "migrations", "0006_faturamento_connect_outbox.sql");
        Assert.True(File.Exists(path));
        var sql = File.ReadAllText(path);

        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.fatura", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.titulo_financeiro", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.mensagem_template", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.mensagem_envio", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.outbox_evento", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Fatura_Sem_Cliente_Falha()
    {
        Assert.Throws<ArgumentException>(() => new Invoice(Guid.NewGuid(), Guid.Empty, "FAT-1"));
    }

    [Fact]
    public void Fatura_Sem_Item_Nao_Emite()
    {
        var invoice = new Invoice(Guid.NewGuid(), Guid.NewGuid(), "FAT-1");
        Assert.Throws<InvalidOperationException>(() => invoice.Issue());
    }

    [Fact]
    public void Fatura_Emitida_Nao_Altera_Item()
    {
        var invoice = new Invoice(Guid.NewGuid(), Guid.NewGuid(), "FAT-1");
        invoice.AddItem(new InvoiceItem(Guid.NewGuid(), "Produto", 1, 10, 0));
        invoice.Issue();
        Assert.Throws<InvalidOperationException>(() => invoice.AddItem(new InvoiceItem(Guid.NewGuid(), "Outro", 1, 10, 0)));
    }

    [Fact]
    public void Titulo_Calcula_Valor_Aberto_E_Nao_Baixa_Duas_Vezes()
    {
        var title = new FinancialTitle(Guid.NewGuid(), Guid.NewGuid(), "TIT-1", DateOnly.FromDateTime(DateTime.UtcNow.AddDays(7)), 100);
        title.RegisterPayment(100);

        Assert.Equal(0, title.OpenAmount);
        Assert.Throws<InvalidOperationException>(() => title.RegisterPayment(1));
    }

    [Fact]
    public void Titulo_Cancelado_Nao_Envia()
    {
        var title = new FinancialTitle(Guid.NewGuid(), Guid.NewGuid(), "TIT-1", DateOnly.FromDateTime(DateTime.UtcNow.AddDays(7)), 100);
        title.Cancel();
        Assert.Throws<InvalidOperationException>(() => title.Send());
    }

    [Fact]
    public void Template_Sem_Corpo_Falha()
    {
        Assert.Throws<ArgumentException>(() => new MessageTemplate(Guid.NewGuid(), "codigo", "Nome", MessageChannel.Email, ""));
    }

    [Fact]
    public void Outbox_Acima_De_Max_Tentativas_Nao_Reprocessa_Automaticamente()
    {
        var outbox = new OutboxEvent(Guid.NewGuid(), "connect.mensagem.enfileirada", 1);
        outbox.MarkError();
        Assert.False(outbox.CanRetryAutomatically());
    }
}
