using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Npgsql;

namespace IntegraRP.Api.Controllers;

[ApiController]
[AllowAnonymous]
[Route("api")]
public sealed class V110RuntimeController(IConfiguration configuration, ILogger<V110RuntimeController> logger) : ControllerBase
{
    [HttpGet("customers")]
    public Task<IActionResult> Customers(CancellationToken ct) => Query("clientes", "SELECT c.id, c.nome, c.documento, c.email, c.status FROM integrarp.cliente c JOIN integrarp.tenant t ON t.id=c.tenant_id AND t.slug='demo' WHERE c.excluido_em IS NULL ORDER BY c.criado_em, c.nome;", ct);

    [HttpPost("customers")]
    public async Task<IActionResult> CreateCustomer([FromBody] DemoCustomerRequest request, CancellationToken ct)
    {
        var nome = string.IsNullOrWhiteSpace(request.Nome) ? $"Cliente Homologação {DateTimeOffset.UtcNow:yyyyMMddHHmmss}" : request.Nome.Trim();
        return await Query("cliente criado", @"WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo')
INSERT INTO integrarp.cliente (tenant_id,nome,documento,email,metadata_json) SELECT tenant_id,@nome,@documento,@email,'{""origem"":""api-v1.10""}'::jsonb FROM t
ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET documento=EXCLUDED.documento,email=EXCLUDED.email,atualizado_em=now()
RETURNING id,nome,documento,email,status;", ct, new NpgsqlParameter("nome", nome), new NpgsqlParameter("documento", (object?)request.Documento ?? DBNull.Value), new NpgsqlParameter("email", (object?)request.Email ?? DBNull.Value));
    }

    [HttpPut("customers/{id:guid}")]
    public Task<IActionResult> UpdateCustomer(Guid id, [FromBody] DemoCustomerRequest request, CancellationToken ct) => Query("cliente atualizado", @"UPDATE integrarp.cliente SET nome=COALESCE(NULLIF(@nome,''),nome),documento=@documento,email=@email,atualizado_em=now() WHERE id=@id AND excluido_em IS NULL RETURNING id,nome,documento,email,status;", ct, new NpgsqlParameter("id", id), new NpgsqlParameter("nome", (object?)request.Nome?.Trim() ?? DBNull.Value), new NpgsqlParameter("documento", (object?)request.Documento ?? DBNull.Value), new NpgsqlParameter("email", (object?)request.Email ?? DBNull.Value));

    [HttpGet("products")]
    public Task<IActionResult> Products(CancellationToken ct) => Query("produtos", "SELECT p.id,p.sku,p.nome,p.status,p.estoque_minimo AS estoqueMinimo,p.estoque_atual AS estoqueAtual FROM integrarp.produto p JOIN integrarp.tenant t ON t.id=p.tenant_id AND t.slug='demo' WHERE p.excluido_em IS NULL ORDER BY p.criado_em,p.sku;", ct);

    [HttpPost("products")]
    public Task<IActionResult> CreateProduct([FromBody] DemoProductRequest request, CancellationToken ct)
    {
        var sku = string.IsNullOrWhiteSpace(request.Sku) ? $"HML-{DateTimeOffset.UtcNow:yyyyMMddHHmmss}" : request.Sku.Trim();
        var nome = string.IsNullOrWhiteSpace(request.Nome) ? $"Produto Homologação {sku}" : request.Nome.Trim();
        return Query("produto criado", @"WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), cat AS (SELECT pc.id FROM integrarp.produto_categoria pc JOIN t ON t.tenant_id=pc.tenant_id ORDER BY pc.nome LIMIT 1)
INSERT INTO integrarp.produto (tenant_id,categoria_id,sku,nome,estoque_minimo,estoque_atual,metadata_json) SELECT t.tenant_id,cat.id,@sku,@nome,@minimo,@saldo,'{""origem"":""api-v1.10""}'::jsonb FROM t LEFT JOIN cat ON true
ON CONFLICT (tenant_id,sku) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome,estoque_minimo=EXCLUDED.estoque_minimo,estoque_atual=EXCLUDED.estoque_atual,atualizado_em=now()
RETURNING id,sku,nome,estoque_minimo AS estoqueMinimo,estoque_atual AS estoqueAtual;", ct, new NpgsqlParameter("sku", sku), new NpgsqlParameter("nome", nome), new NpgsqlParameter("minimo", request.EstoqueMinimo), new NpgsqlParameter("saldo", request.EstoqueAtual));
    }

    [HttpPut("products/{id:guid}")]
    public Task<IActionResult> UpdateProduct(Guid id, [FromBody] DemoProductRequest request, CancellationToken ct)
    {
        var nome = string.IsNullOrWhiteSpace(request.Nome) ? null : request.Nome.Trim();
        return Query("produto atualizado", "UPDATE integrarp.produto SET sku=COALESCE(NULLIF(@sku,''),sku),nome=COALESCE(@nome,nome),estoque_minimo=@minimo,estoque_atual=@saldo,atualizado_em=now() WHERE id=@id AND excluido_em IS NULL RETURNING id,sku,nome,status,estoque_minimo AS estoqueMinimo,estoque_atual AS estoqueAtual;", ct, new NpgsqlParameter("id", id), new NpgsqlParameter("sku", (object?)request.Sku?.Trim() ?? DBNull.Value), new NpgsqlParameter("nome", (object?)nome ?? DBNull.Value), new NpgsqlParameter("minimo", request.EstoqueMinimo), new NpgsqlParameter("saldo", request.EstoqueAtual));
    }

    [HttpPost("inventory/entries")]
    public Task<IActionResult> InventoryEntry([FromBody] DemoInventoryEntryRequest request, CancellationToken ct) => Query("entrada estoque", @"WITH t AS (SELECT id tenant_id FROM integrarp.tenant WHERE slug='demo'), l AS (SELECT id FROM integrarp.estoque_local WHERE codigo='principal' AND tenant_id=(SELECT tenant_id FROM t)), updated AS (UPDATE integrarp.produto SET estoque_atual=estoque_atual+@quantidade, atualizado_em=now() WHERE sku=COALESCE(@sku,'DEMO-A') AND tenant_id=(SELECT tenant_id FROM t) RETURNING *)
INSERT INTO integrarp.estoque_movimento (tenant_id,produto_id,local_id,tipo,quantidade,saldo_apos,metadata_json) SELECT updated.tenant_id,updated.id,l.id,'entrada',@quantidade,updated.estoque_atual,'{""origem"":""api-v1.10""}'::jsonb FROM updated,l RETURNING id,tipo,quantidade,saldo_apos AS saldoApos;", ct, new NpgsqlParameter("sku", (object?)request.Sku ?? "DEMO-A"), new NpgsqlParameter("quantidade", request.Quantidade <= 0 ? 1 : request.Quantidade));

    [HttpGet("orders")]
    public Task<IActionResult> Orders(CancellationToken ct) => Query("pedidos", "SELECT p.id,p.numero,p.status,p.valor_total AS valorTotal,c.nome AS cliente FROM integrarp.pedido p JOIN integrarp.tenant t ON t.id=p.tenant_id AND t.slug='demo' LEFT JOIN integrarp.cliente c ON c.id=p.cliente_id WHERE p.excluido_em IS NULL ORDER BY p.criado_em,p.numero;", ct);

    [HttpPost("orders/{id:guid}/confirm")]
    public Task<IActionResult> ConfirmOrder(Guid id, CancellationToken ct) => Query("pedido confirmado", "UPDATE integrarp.pedido SET status='confirmado', atualizado_em=now() WHERE id=@id RETURNING id,numero,status;", ct, new NpgsqlParameter("id", id));

    [HttpGet("tasks/my")]
    public Task<IActionResult> Tasks(CancellationToken ct) => Query("tarefas", "SELECT id,codigo,titulo,status,vencimento_em AS vencimentoEm,responsavel_email AS responsavelEmail FROM integrarp.tarefa_operacional WHERE excluido_em IS NULL ORDER BY status, vencimento_em NULLS LAST;", ct);

    [HttpPost("tasks/{id:guid}/complete")]
    public Task<IActionResult> CompleteTask(Guid id, CancellationToken ct) => Query("tarefa concluída", "UPDATE integrarp.tarefa_operacional SET status='concluida', atualizado_em=now() WHERE id=@id RETURNING id,codigo,titulo,status;", ct, new NpgsqlParameter("id", id));

    private async Task<IActionResult> Query(string title, string sql, CancellationToken ct, params NpgsqlParameter[] parameters)
    { try { var rows = await V19Db.QueryAsync(configuration, sql, ct, parameters); return Ok(rows.Count == 1 ? rows[0] : rows); } catch (Exception ex) { logger.LogError(ex, "Falha runtime v1.10 em {Title}", title); return Problem(ex.Message, statusCode: 503, title: $"{title} indisponível"); } }
}

public sealed record DemoCustomerRequest(string? Nome, string? Documento, string? Email);
public sealed record DemoProductRequest(string? Sku, string? Nome, decimal EstoqueMinimo = 0, decimal EstoqueAtual = 0);
public sealed record DemoInventoryEntryRequest(string? Sku, decimal Quantidade = 1);
