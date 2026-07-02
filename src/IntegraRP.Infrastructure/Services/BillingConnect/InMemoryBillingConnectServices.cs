using System.Collections.Concurrent;
using System.Text.Json;
using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Contracts.Billing;
using IntegraRP.Contracts.Connect;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Services.BillingConnect;

public sealed class InMemoryBillingService(ILogger<InMemoryBillingService> logger, IBoletoProvider boletoProvider) : IBillingService
{
    private readonly ConcurrentDictionary<Guid, InvoiceStore> _invoices = new();
    private readonly ConcurrentDictionary<Guid, TitleStore> _titles = new();
    private readonly ConcurrentDictionary<Guid, FiscalDocumentReferenceResponse> _fiscalDocuments = new();

    public Task<InvoiceDetailResponse> CreateInvoiceAsync(Guid tenantId, CreateInvoiceRequest request, CancellationToken cancellationToken)
    {
        var invoice = new InvoiceStore(Guid.NewGuid(), tenantId, request.PedidoId, request.ClienteId, request.Codigo ?? $"FAT-{DateTime.UtcNow:yyyyMMddHHmmss}", "rascunho", null, request.DataVencimento, []);
        _invoices[invoice.Id] = invoice;
        logger.LogInformation("Auditoria faturamento.fatura.criada {InvoiceId}", invoice.Id);
        return Task.FromResult(ToDetail(invoice));
    }

    public async Task<InvoiceDetailResponse> CreateInvoiceFromOrderAsync(Guid tenantId, Guid orderId, CreateInvoiceFromOrderRequest request, CancellationToken cancellationToken)
    {
        var detail = await CreateInvoiceAsync(tenantId, new CreateInvoiceRequest(request.ClienteId, orderId, request.Codigo, request.DataVencimento, "Gerada a partir de pedido"), cancellationToken);
        await AddInvoiceItemAsync(tenantId, detail.Invoice.Id, new AddInvoiceItemRequest("Item demonstrativo do pedido", 1, 100, 0, null, null), cancellationToken);
        logger.LogInformation("Auditoria pedido.faturamento_vinculado {OrderId}", orderId);
        return (await GetInvoiceAsync(tenantId, detail.Invoice.Id, cancellationToken))!;
    }

    public Task<InvoiceDetailResponse?> GetInvoiceAsync(Guid tenantId, Guid id, CancellationToken cancellationToken)
        => Task.FromResult(_invoices.TryGetValue(id, out var invoice) && invoice.TenantId == tenantId ? ToDetail(invoice) : null);

    public Task<IReadOnlyList<InvoiceResponse>> ListInvoicesAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken)
        => Task.FromResult<IReadOnlyList<InvoiceResponse>>(_invoices.Values.Where(x => x.TenantId == tenantId && (string.IsNullOrWhiteSpace(status) || x.Status == status)).Skip((Math.Max(page, 1) - 1) * Math.Clamp(pageSize, 1, 100)).Take(Math.Clamp(pageSize, 1, 100)).Select(ToResponse).ToList());

    public Task<InvoiceDetailResponse> AddInvoiceItemAsync(Guid tenantId, Guid invoiceId, AddInvoiceItemRequest request, CancellationToken cancellationToken)
    {
        var invoice = RequireInvoice(tenantId, invoiceId);
        if (invoice.Status != "rascunho") throw new InvalidOperationException("Fatura emitida não pode alterar itens.");
        invoice.Items.Add(new InvoiceItemResponse(Guid.NewGuid(), request.Descricao, request.Quantidade, request.ValorUnitario, request.ValorDesconto, decimal.Round((request.Quantidade * request.ValorUnitario) - request.ValorDesconto, 2)));
        return Task.FromResult(ToDetail(invoice));
    }

    public Task<InvoiceDetailResponse> IssueInvoiceAsync(Guid tenantId, Guid invoiceId, IssueInvoiceRequest request, CancellationToken cancellationToken)
    {
        var invoice = RequireInvoice(tenantId, invoiceId);
        if (invoice.Items.Count == 0) throw new InvalidOperationException("Fatura precisa ter pelo menos um item.");
        invoice.Status = "emitida";
        invoice.DataEmissao = DateTimeOffset.UtcNow;
        invoice.DataVencimento = request.DataVencimento ?? DateOnly.FromDateTime(DateTime.UtcNow.AddDays(7));
        logger.LogInformation("Auditoria faturamento.fatura.emitida {InvoiceId}", invoiceId);
        return Task.FromResult(ToDetail(invoice));
    }

    public Task<FinancialTitleResponse> CreateTitleAsync(Guid tenantId, CreateFinancialTitleRequest request, CancellationToken cancellationToken)
    {
        var title = new TitleStore(Guid.NewGuid(), tenantId, request.FaturaId, request.PedidoId, request.ClienteId, request.Codigo ?? $"TIT-{DateTime.UtcNow:yyyyMMddHHmmss}", "aberto", request.Descricao, request.DataVencimento, request.ValorOriginal, request.ValorOriginal, null, null, null);
        _titles[title.Id] = title;
        logger.LogInformation("Auditoria faturamento.titulo.criado {TitleId}", title.Id);
        return Task.FromResult(ToResponse(title));
    }

    public async Task<FinancialTitleResponse> CreateTitleFromInvoiceAsync(Guid tenantId, Guid invoiceId, CreateTitleFromInvoiceRequest request, CancellationToken cancellationToken)
    {
        var invoice = RequireInvoice(tenantId, invoiceId);
        var total = invoice.Items.Sum(x => x.ValorTotal);
        return await CreateTitleAsync(tenantId, new CreateFinancialTitleRequest(invoice.ClienteId, invoice.Id, invoice.PedidoId, null, $"Título da fatura {invoice.Codigo}", request.DataVencimento ?? invoice.DataVencimento ?? DateOnly.FromDateTime(DateTime.UtcNow.AddDays(7)), total), cancellationToken);
    }

    public async Task<GenerateFakeBoletoResponse> GenerateBoletoAsync(Guid tenantId, Guid titleId, GenerateFakeBoletoRequest request, CancellationToken cancellationToken)
    {
        var title = RequireTitle(tenantId, titleId);
        var boleto = await boletoProvider.GenerateAsync(title.Id, title.ValorAberto, cancellationToken);
        title.LinkBoleto = boleto.LinkBoleto;
        title.LinhaDigitavel = boleto.LinhaDigitavel;
        title.Status = "enviado";
        logger.LogInformation("Auditoria faturamento.boleto.gerado {TitleId} {BoletoLogId}", titleId, boleto.BoletoLogId);
        return boleto;
    }

    public Task<BillingDashboardResponse> GetDashboardAsync(Guid tenantId, CancellationToken cancellationToken)
    {
        var invoices = _invoices.Values.Where(x => x.TenantId == tenantId).ToList();
        var titles = _titles.Values.Where(x => x.TenantId == tenantId).ToList();
        return Task.FromResult(new BillingDashboardResponse(invoices.Sum(x => x.Items.Sum(i => i.ValorTotal)), invoices.Count(x => x.Status == "emitida"), titles.Count(x => x.Status is "aberto" or "enviado"), titles.Count(x => x.Status == "vencido"), titles.Sum(x => x.ValorAberto), titles.Where(x => x.Status == "vencido").Sum(x => x.ValorAberto), 1.5, 0.8, 0.1));
    }

    public Task<IReadOnlyList<FinancialTitleResponse>> ListTitlesAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken)
        => Task.FromResult<IReadOnlyList<FinancialTitleResponse>>(_titles.Values.Where(x => x.TenantId == tenantId && (string.IsNullOrWhiteSpace(status) || x.Status == status)).Skip((Math.Max(page, 1) - 1) * Math.Clamp(pageSize, 1, 100)).Take(Math.Clamp(pageSize, 1, 100)).Select(ToResponse).ToList());

    public Task<FinancialTitleResponse?> GetTitleAsync(Guid tenantId, Guid id, CancellationToken cancellationToken)
        => Task.FromResult(_titles.TryGetValue(id, out var title) && title.TenantId == tenantId ? ToResponse(title) : null);

    public Task<FiscalDocumentReferenceResponse> CreateFiscalDocumentAsync(Guid tenantId, CreateFiscalDocumentReferenceRequest request, CancellationToken cancellationToken)
    {
        var doc = new FiscalDocumentReferenceResponse(Guid.NewGuid(), tenantId, request.FaturaId, request.PedidoId, request.ClienteId, request.Tipo, "referenciada", request.Numero ?? $"FAKE-NFE-{DateTime.UtcNow:yyyyMMddHHmmss}", request.Serie, $"FAKE-NFE-{Guid.NewGuid():N}", request.ValorTotal);
        _fiscalDocuments[doc.Id] = doc;
        logger.LogInformation("Auditoria faturamento.nf.referencia.criada {FiscalDocumentId}", doc.Id);
        return Task.FromResult(doc);
    }

    public Task<IReadOnlyList<FiscalDocumentReferenceResponse>> ListFiscalDocumentsAsync(Guid tenantId, int page, int pageSize, CancellationToken cancellationToken)
        => Task.FromResult<IReadOnlyList<FiscalDocumentReferenceResponse>>(_fiscalDocuments.Values.Where(x => x.TenantId == tenantId).Skip((Math.Max(page, 1) - 1) * Math.Clamp(pageSize, 1, 100)).Take(Math.Clamp(pageSize, 1, 100)).ToList());

    public Task<int> MarkOverdueTitlesAsync(CancellationToken cancellationToken)
    {
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var count = 0;
        foreach (var title in _titles.Values.Where(x => x.DataVencimento < today && x.Status is "aberto" or "enviado"))
        {
            title.Status = "vencido";
            count++;
        }
        return Task.FromResult(count);
    }

    private InvoiceStore RequireInvoice(Guid tenantId, Guid id) => _invoices.TryGetValue(id, out var invoice) && invoice.TenantId == tenantId ? invoice : throw new KeyNotFoundException("Fatura não encontrada.");
    private TitleStore RequireTitle(Guid tenantId, Guid id) => _titles.TryGetValue(id, out var title) && title.TenantId == tenantId ? title : throw new KeyNotFoundException("Título não encontrado.");
    private static InvoiceResponse ToResponse(InvoiceStore x) => new(x.Id, x.TenantId, x.PedidoId, x.ClienteId, x.Codigo, x.Status, x.DataEmissao, x.DataVencimento, x.Items.Sum(i => i.ValorTotal));
    private static InvoiceDetailResponse ToDetail(InvoiceStore x) => new(ToResponse(x), x.Items);
    private static FinancialTitleResponse ToResponse(TitleStore x) => new(x.Id, x.TenantId, x.FaturaId, x.PedidoId, x.ClienteId, x.Codigo, x.Status, x.Descricao, x.DataVencimento, x.ValorOriginal, x.ValorAberto, x.LinkBoleto);

    private sealed class InvoiceStore(Guid id, Guid tenantId, Guid? pedidoId, Guid clienteId, string codigo, string status, DateTimeOffset? dataEmissao, DateOnly? dataVencimento, List<InvoiceItemResponse> items)
    {
        public Guid Id { get; } = id;
        public Guid TenantId { get; } = tenantId;
        public Guid? PedidoId { get; } = pedidoId;
        public Guid ClienteId { get; } = clienteId;
        public string Codigo { get; } = codigo;
        public string Status { get; set; } = status;
        public DateTimeOffset? DataEmissao { get; set; } = dataEmissao;
        public DateOnly? DataVencimento { get; set; } = dataVencimento;
        public List<InvoiceItemResponse> Items { get; } = items;
    }

    private sealed class TitleStore(Guid id, Guid tenantId, Guid? faturaId, Guid? pedidoId, Guid clienteId, string codigo, string status, string descricao, DateOnly dataVencimento, decimal valorOriginal, decimal valorAberto, string? linkBoleto, string? linhaDigitavel, string? codigoBarras)
    {
        public Guid Id { get; } = id;
        public Guid TenantId { get; } = tenantId;
        public Guid? FaturaId { get; } = faturaId;
        public Guid? PedidoId { get; } = pedidoId;
        public Guid ClienteId { get; } = clienteId;
        public string Codigo { get; } = codigo;
        public string Status { get; set; } = status;
        public string Descricao { get; } = descricao;
        public DateOnly DataVencimento { get; } = dataVencimento;
        public decimal ValorOriginal { get; } = valorOriginal;
        public decimal ValorAberto { get; set; } = valorAberto;
        public string? LinkBoleto { get; set; } = linkBoleto;
        public string? LinhaDigitavel { get; set; } = linhaDigitavel;
        public string? CodigoBarras { get; } = codigoBarras;
    }
}

public sealed class FakeBoletoProvider(IConfiguration configuration, ILogger<FakeBoletoProvider> logger) : IBoletoProvider
{
    public Task<GenerateFakeBoletoResponse> GenerateAsync(Guid titleId, decimal amount, CancellationToken cancellationToken)
    {
        if (configuration.GetValue<bool>("IntegraRP:FakeProviders:ForceError")) throw new InvalidOperationException("Erro fake configurado para boleto.");
        var token = titleId.ToString("N")[..12].ToUpperInvariant();
        logger.LogInformation("FAKE-BOLETO gerado para título {TitleId} no valor {Amount}", titleId, amount);
        return Task.FromResult(new GenerateFakeBoletoResponse(Guid.NewGuid(), $"/fake/boleto/{token}", $"FAKE-BOLETO {token} {amount:0.00}", $"FAKE-BOLETO-CODIGO-{token}", $"FAKE-BOLETO-{token}"));
    }
}

public sealed class MessageTemplateRenderer : IMessageTemplateRenderer
{
    public RenderMessageTemplateResponse Render(string? subject, string body, IReadOnlyDictionary<string, string> variables)
    {
        var warnings = new List<string>();
        string RenderText(string? text)
        {
            if (string.IsNullOrEmpty(text)) return string.Empty;
            return System.Text.RegularExpressions.Regex.Replace(text, "\\{\\{([a-zA-Z0-9_]+)\\}\\}", match =>
            {
                var key = match.Groups[1].Value;
                if (variables.TryGetValue(key, out var value)) return value.Replace("<script", "&lt;script", StringComparison.OrdinalIgnoreCase);
                warnings.Add($"Variável sem valor: {key}");
                return $"[[{key}]]";
            });
        }
        return new RenderMessageTemplateResponse(RenderText(subject), RenderText(body), warnings);
    }
}

public sealed class InMemoryConnectService(ILogger<InMemoryConnectService> logger, IMessageTemplateRenderer renderer, IConfiguration configuration) : IConnectService, IMessageDispatcher, IOutboxProcessor
{
    private readonly ConcurrentDictionary<Guid, MessageTemplateResponse> _templates = new();
    private readonly ConcurrentDictionary<Guid, MessageDispatchResponse> _messages = new();
    private readonly ConcurrentDictionary<Guid, OutboxEventResponse> _outbox = new();

    public Task<MessageTemplateResponse> CreateTemplateAsync(Guid tenantId, CreateMessageTemplateRequest request, CancellationToken cancellationToken)
    {
        var item = new MessageTemplateResponse(Guid.NewGuid(), tenantId, request.Codigo, request.Nome, request.Canal, request.Categoria, request.AssuntoTemplate, request.CorpoTemplate, true, request.Publico);
        _templates[item.Id] = item;
        logger.LogInformation("Auditoria connect.template.criado {TemplateId}", item.Id);
        return Task.FromResult(item);
    }

    public Task<MessageTemplateResponse> UpdateTemplateAsync(Guid tenantId, Guid id, UpdateMessageTemplateRequest request, CancellationToken cancellationToken)
    {
        var old = _templates[id];
        var item = old with { Nome = request.Nome, Categoria = request.Categoria, AssuntoTemplate = request.AssuntoTemplate, CorpoTemplate = request.CorpoTemplate, Ativo = request.Ativo, Publico = request.Publico };
        _templates[id] = item;
        logger.LogInformation("Auditoria connect.template.atualizado {TemplateId}", id);
        return Task.FromResult(item);
    }

    public Task<IReadOnlyList<MessageTemplateResponse>> ListTemplatesAsync(Guid tenantId, string? canal, CancellationToken cancellationToken)
        => Task.FromResult<IReadOnlyList<MessageTemplateResponse>>(_templates.Values.Where(x => (x.TenantId == tenantId || x.TenantId is null) && (string.IsNullOrWhiteSpace(canal) || x.Canal == canal)).ToList());

    public Task<RenderMessageTemplateResponse> RenderTemplateAsync(Guid tenantId, Guid id, RenderMessageTemplateRequest request, CancellationToken cancellationToken)
    {
        var template = _templates[id];
        return Task.FromResult(renderer.Render(template.AssuntoTemplate, template.CorpoTemplate, request.Variaveis));
    }

    public Task<MessageDispatchResponse> SendMessageAsync(Guid tenantId, SendMessageRequest request, CancellationToken cancellationToken) => DispatchAsync(tenantId, request, cancellationToken);

    public Task<MessageDispatchResponse> DispatchAsync(Guid tenantId, SendMessageRequest request, CancellationToken cancellationToken)
    {
        var forceError = configuration.GetValue<bool>("IntegraRP:FakeProviders:ForceError");
        var prefix = request.Canal.ToLowerInvariant() switch { "whatsapp" => "FAKE-WHATSAPP", "telegram" => "FAKE-TELEGRAM", "email" => "FAKE-EMAIL", _ => "FAKE-CONNECT" };
        logger.LogInformation("{Prefix} envio fake/log para {Recipient}: {Body}", prefix, request.Destinatario, request.Corpo);
        var item = new MessageDispatchResponse(Guid.NewGuid(), tenantId, request.Canal, forceError ? "erro" : "enviado", request.Assunto, request.Corpo, forceError ? "Erro fake configurado." : null, 1, forceError ? null : DateTimeOffset.UtcNow);
        _messages[item.Id] = item;
        return Task.FromResult(item);
    }

    public Task<OutboxEventResponse> QueueOutboxAsync(Guid tenantId, QueueOutboxEventRequest request, CancellationToken cancellationToken)
    {
        var item = new OutboxEventResponse(Guid.NewGuid(), tenantId, request.TipoEvento, request.Canal, request.OrigemTipo, request.OrigemId, request.Prioridade, "pendente", 0, 5, null, DateTimeOffset.UtcNow);
        _outbox[item.Id] = item;
        logger.LogInformation("Auditoria outbox.evento.criado {OutboxId} {Payload}", item.Id, JsonSerializer.Serialize(request.Payload));
        return Task.FromResult(item);
    }

    public Task<IReadOnlyList<OutboxEventResponse>> ListOutboxAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken)
        => Task.FromResult<IReadOnlyList<OutboxEventResponse>>(_outbox.Values.Where(x => x.TenantId == tenantId && (string.IsNullOrWhiteSpace(status) || x.Status == status)).Skip((Math.Max(page, 1) - 1) * Math.Clamp(pageSize, 1, 100)).Take(Math.Clamp(pageSize, 1, 100)).ToList());

    public Task<OutboxEventResponse?> GetOutboxAsync(Guid tenantId, Guid id, CancellationToken cancellationToken)
        => Task.FromResult(_outbox.TryGetValue(id, out var item) && item.TenantId == tenantId ? item : null);

    public Task<OutboxEventResponse> ProcessOutboxAsync(Guid tenantId, Guid id, CancellationToken cancellationToken)
    {
        var item = _outbox[id];
        var processed = item with { Status = configuration.GetValue<bool>("IntegraRP:FakeProviders:ForceError") ? "erro" : "processado", Tentativas = item.Tentativas + 1, Erro = configuration.GetValue<bool>("IntegraRP:FakeProviders:ForceError") ? "Erro fake configurado." : null };
        _outbox[id] = processed;
        logger.LogInformation("Auditoria outbox.evento.processado {OutboxId} {Status}", id, processed.Status);
        return Task.FromResult(processed);
    }

    public async Task<int> ProcessPendingOutboxAsync(CancellationToken cancellationToken)
    {
        var pending = _outbox.Values.Where(x => x.Status == "pendente" || (x.Status == "erro" && x.Tentativas < x.MaxTentativas)).ToList();
        foreach (var item in pending) await ProcessOutboxAsync(item.TenantId, item.Id, cancellationToken);
        return pending.Count;
    }

    public Task<ConnectDashboardResponse> GetDashboardAsync(Guid tenantId, CancellationToken cancellationToken)
        => Task.FromResult(new ConnectDashboardResponse(_messages.Values.Count(x => x.TenantId == tenantId && x.Status == "pendente"), _messages.Values.Count(x => x.TenantId == tenantId && x.Status == "enviado"), _messages.Values.Count(x => x.TenantId == tenantId && x.Status == "erro"), _outbox.Values.Count(x => x.TenantId == tenantId && x.Status == "pendente"), _outbox.Values.Count(x => x.TenantId == tenantId && x.Status == "processado"), _outbox.Values.Count(x => x.TenantId == tenantId && x.Status == "erro"), 0.5, _messages.Values.DefaultIfEmpty().Average(x => x?.Tentativas ?? 0)));

    public Task<IReadOnlyList<MessageDispatchResponse>> ListMessagesAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken cancellationToken)
        => Task.FromResult<IReadOnlyList<MessageDispatchResponse>>(_messages.Values.Where(x => x.TenantId == tenantId && (string.IsNullOrWhiteSpace(status) || x.Status == status)).Skip((Math.Max(page, 1) - 1) * Math.Clamp(pageSize, 1, 100)).Take(Math.Clamp(pageSize, 1, 100)).ToList());
}

public sealed class FakeFiscalDocumentProvider : IFiscalDocumentProvider { }
public sealed class FakeEmailSender : IEmailSender { }
public sealed class FakeWhatsAppSender : IWhatsAppSender { }
public sealed class FakeTelegramSender : ITelegramSender { }
public sealed class FakeWebhookSender : IWebhookSender { }
