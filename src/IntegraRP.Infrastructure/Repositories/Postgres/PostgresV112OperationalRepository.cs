using System.Data.Common;
using IntegraRP.Application.Runtime;
using Microsoft.Extensions.Logging;
using Npgsql;

namespace IntegraRP.Infrastructure.Repositories.Postgres;

public sealed class PostgresV112OperationalRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresV112OperationalRepository> logger) : IOperationalRuntimeRepository
{
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListCustomersAsync(Guid tenantId, CancellationToken ct) => QueryAsync("""
        SELECT c.id, c.nome, c.documento, c.email, c.status
        FROM integrarp.cliente c
        WHERE c.tenant_id = @tenant_id AND c.excluido_em IS NULL
        ORDER BY c.criado_em, c.nome LIMIT 100;
        """, ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> GetCustomerAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("SELECT id,nome,documento,email,status FROM integrarp.cliente WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> CreateCustomerAsync(Guid tenantId, DemoCustomerRequest r, CancellationToken ct) => FirstAsync("""
        INSERT INTO integrarp.cliente (tenant_id,nome,documento,email,metadata_json)
        VALUES (@tenant_id,@nome,@documento,@email,'{"origem":"api-v1.12"}'::jsonb)
        ON CONFLICT (tenant_id,nome) WHERE excluido_em IS NULL DO UPDATE SET documento=EXCLUDED.documento,email=EXCLUDED.email,atualizado_em=now()
        RETURNING id,nome,documento,email,status;
        """, ct, P("tenant_id", tenantId), P("nome", Clean(r.Nome, $"Cliente Homologação {DateTimeOffset.UtcNow:yyyyMMddHHmmss}")), P("documento", r.Documento), P("email", r.Email));
    public Task<IDictionary<string, object?>?> UpdateCustomerAsync(Guid tenantId, Guid id, DemoCustomerRequest r, CancellationToken ct) => FirstAsync("""
        UPDATE integrarp.cliente SET nome=COALESCE(NULLIF(@nome,''),nome),documento=@documento,email=@email,atualizado_em=now()
        WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,nome,documento,email,status;
        """, ct, P("tenant_id", tenantId), P("id", id), P("nome", r.Nome?.Trim()), P("documento", r.Documento), P("email", r.Email));
    public Task<IDictionary<string, object?>?> DeleteCustomerAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.cliente SET excluido_em=now(), status='inativo', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,nome,status,excluido_em AS \"excluidoEm\";", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListProductsAsync(Guid tenantId, CancellationToken ct) => QueryAsync("""
        SELECT p.id,p.sku,p.nome,p.status,p.estoque_minimo AS "estoqueMinimo",p.estoque_atual AS "estoqueAtual"
        FROM integrarp.produto p WHERE p.tenant_id=@tenant_id AND p.excluido_em IS NULL ORDER BY p.criado_em,p.sku LIMIT 100;
        """, ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> GetProductAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("SELECT id,sku,nome,status,estoque_minimo AS \"estoqueMinimo\",estoque_atual AS \"estoqueAtual\" FROM integrarp.produto WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> CreateProductAsync(Guid tenantId, DemoProductRequest r, CancellationToken ct) => FirstAsync("""
        WITH cat AS (SELECT id FROM integrarp.produto_categoria WHERE tenant_id=@tenant_id ORDER BY nome LIMIT 1)
        INSERT INTO integrarp.produto (tenant_id,categoria_id,sku,nome,estoque_minimo,estoque_atual,metadata_json)
        SELECT @tenant_id,cat.id,@sku,@nome,@minimo,@saldo,'{"origem":"api-v1.12"}'::jsonb FROM cat
        ON CONFLICT (tenant_id,sku) WHERE excluido_em IS NULL DO UPDATE SET nome=EXCLUDED.nome,estoque_minimo=EXCLUDED.estoque_minimo,estoque_atual=EXCLUDED.estoque_atual,atualizado_em=now()
        RETURNING id,sku,nome,estoque_minimo AS "estoqueMinimo",estoque_atual AS "estoqueAtual";
        """, ct, P("tenant_id", tenantId), P("sku", Clean(r.Sku, $"HML-{DateTimeOffset.UtcNow:yyyyMMddHHmmss}")), P("nome", Clean(r.Nome, $"Produto Homologação {DateTimeOffset.UtcNow:yyyyMMddHHmmss}")), P("minimo", r.EstoqueMinimo), P("saldo", r.EstoqueAtual));
    public Task<IDictionary<string, object?>?> UpdateProductAsync(Guid tenantId, Guid id, DemoProductRequest r, CancellationToken ct) => FirstAsync("""
        UPDATE integrarp.produto SET sku=COALESCE(NULLIF(@sku,''),sku),nome=COALESCE(NULLIF(@nome,''),nome),estoque_minimo=@minimo,estoque_atual=@saldo,atualizado_em=now()
        WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,sku,nome,status,estoque_minimo AS "estoqueMinimo",estoque_atual AS "estoqueAtual";
        """, ct, P("tenant_id", tenantId), P("id", id), P("sku", r.Sku?.Trim()), P("nome", r.Nome?.Trim()), P("minimo", r.EstoqueMinimo), P("saldo", r.EstoqueAtual));
    public Task<IDictionary<string, object?>?> DeleteProductAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.produto SET excluido_em=now(), status='inativo', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,sku,nome,status,excluido_em AS \"excluidoEm\";", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListInventoryBalanceAsync(Guid tenantId, CancellationToken ct) => QueryAsync("SELECT p.id AS produto_id,p.sku,p.nome,p.estoque_atual AS \"estoqueAtual\",p.estoque_minimo AS \"estoqueMinimo\",CASE WHEN p.estoque_atual < p.estoque_minimo THEN 'critico' ELSE 'ok' END AS status FROM integrarp.produto p WHERE p.tenant_id=@tenant_id AND p.excluido_em IS NULL ORDER BY p.nome LIMIT 100;", ct, P("tenant_id", tenantId));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListInventoryMovementsAsync(Guid tenantId, CancellationToken ct) => QueryAsync("SELECT m.id,m.tipo,m.quantidade,m.saldo_apos AS \"saldoApos\",m.criado_em AS \"criadoEm\",p.sku,p.nome AS produto FROM integrarp.estoque_movimento m JOIN integrarp.produto p ON p.id=m.produto_id AND p.tenant_id=m.tenant_id WHERE m.tenant_id=@tenant_id AND m.excluido_em IS NULL ORDER BY m.criado_em DESC LIMIT 100;", ct, P("tenant_id", tenantId));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListCriticalInventoryAsync(Guid tenantId, CancellationToken ct) => QueryAsync("SELECT p.id,p.sku,p.nome,p.estoque_atual AS \"estoqueAtual\",p.estoque_minimo AS \"estoqueMinimo\" FROM integrarp.produto p WHERE p.tenant_id=@tenant_id AND p.excluido_em IS NULL AND p.estoque_atual < p.estoque_minimo ORDER BY p.estoque_atual,p.nome LIMIT 100;", ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> RegisterInventoryEntryAsync(Guid tenantId, DemoInventoryEntryRequest r, CancellationToken ct) => FirstAsync("""
        WITH l AS (SELECT id FROM integrarp.estoque_local WHERE codigo='principal' AND tenant_id=@tenant_id), updated AS (UPDATE integrarp.produto SET estoque_atual=estoque_atual+@quantidade, atualizado_em=now() WHERE tenant_id=@tenant_id AND sku=COALESCE(@sku,'DEMO-A') RETURNING id,tenant_id,estoque_atual)
        INSERT INTO integrarp.estoque_movimento (tenant_id,produto_id,local_id,tipo,quantidade,saldo_apos,metadata_json) SELECT updated.tenant_id,updated.id,l.id,'entrada',@quantidade,updated.estoque_atual,'{"origem":"api-v1.12"}'::jsonb FROM updated,l RETURNING id,tipo,quantidade,saldo_apos AS "saldoApos";
        """, ct, P("tenant_id", tenantId), P("sku", r.Sku), P("quantidade", r.Quantidade <= 0 ? 1 : r.Quantidade));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListOrdersAsync(Guid tenantId, CancellationToken ct) => QueryAsync("SELECT p.id,p.numero,p.status,p.valor_total AS \"valorTotal\",c.nome AS cliente FROM integrarp.pedido p LEFT JOIN integrarp.cliente c ON c.id=p.cliente_id AND c.tenant_id=p.tenant_id WHERE p.tenant_id=@tenant_id AND p.excluido_em IS NULL ORDER BY p.criado_em,p.numero LIMIT 100;", ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> GetOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("SELECT p.id,p.numero,p.status,p.valor_total AS \"valorTotal\",c.nome AS cliente FROM integrarp.pedido p LEFT JOIN integrarp.cliente c ON c.id=p.cliente_id AND c.tenant_id=p.tenant_id WHERE p.tenant_id=@tenant_id AND p.id=@id AND p.excluido_em IS NULL;", ct, P("tenant_id", tenantId), P("id", id));
    public async Task<IDictionary<string, object?>?> CreateOrderAsync(Guid tenantId, CreateOrderRequest request, CancellationToken ct)
    {
        await using var c = await connectionFactory.OpenAsync(ct);
        await using var tx = await c.BeginTransactionAsync(ct);
        try
        {
            var order = await FirstAsync(c, tx, """
                INSERT INTO integrarp.pedido (tenant_id,cliente_id,numero,status,valor_total,metadata_json)
                SELECT @tenant_id,cl.id,'PED-'||to_char(now(),'YYYYMMDDHH24MISSMS'),'rascunho',0,jsonb_build_object('notes',@notes,'expectedDeliveryDate',@expected_delivery_date)
                FROM integrarp.cliente cl
                WHERE cl.tenant_id=@tenant_id AND cl.id=@customer_id AND cl.excluido_em IS NULL
                RETURNING id,numero,status,valor_total AS "valorTotal";
                """, ct, P("tenant_id", tenantId), P("customer_id", request.CustomerId), P("notes", request.Notes), P("expected_delivery_date", request.ExpectedDeliveryDate));
            if (order is null) { await tx.RollbackAsync(ct); return null; }
            var orderId = (Guid)order["id"]!;
            foreach (var item in request.Items)
            {
                await AddOrderItemAsync(c, tx, tenantId, orderId, item, ct);
            }
            var updated = await RecalculateOrderAsync(c, tx, tenantId, orderId, ct);
            await tx.CommitAsync(ct);
            return updated;
        }
        catch
        {
            await tx.RollbackAsync(ct);
            throw;
        }
    }
    public async Task<IDictionary<string, object?>?> AddOrderItemAsync(Guid tenantId, Guid id, AddOrderItemRequest request, CancellationToken ct)
    {
        await using var c = await connectionFactory.OpenAsync(ct);
        await using var tx = await c.BeginTransactionAsync(ct);
        var row = await AddOrderItemAsync(c, tx, tenantId, id, request, ct);
        await RecalculateOrderAsync(c, tx, tenantId, id, ct);
        await tx.CommitAsync(ct);
        return row;
    }
    public async Task<IDictionary<string, object?>?> RemoveOrderItemAsync(Guid tenantId, Guid id, Guid itemId, CancellationToken ct)
    {
        await using var c = await connectionFactory.OpenAsync(ct);
        await using var tx = await c.BeginTransactionAsync(ct);
        var row = await FirstAsync(c, tx, "UPDATE integrarp.pedido_item SET excluido_em=now(), atualizado_em=now() WHERE tenant_id=@tenant_id AND pedido_id=@id AND id=@item_id AND excluido_em IS NULL RETURNING id,pedido_id AS \"pedidoId\",excluido_em AS \"excluidoEm\";", ct, P("tenant_id", tenantId), P("id", id), P("item_id", itemId));
        await RecalculateOrderAsync(c, tx, tenantId, id, ct);
        await tx.CommitAsync(ct);
        return row;
    }
    public Task<IDictionary<string, object?>?> ConfirmOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.pedido SET status='confirmado', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,numero,status;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> CancelOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.pedido SET status='cancelado', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,numero,status;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListMyTasksAsync(Guid tenantId, Guid userId, Guid? sectorId, CancellationToken ct) => QueryAsync("SELECT id,codigo,titulo,status,vencimento_em AS \"vencimentoEm\",responsavel_email AS \"responsavelEmail\" FROM integrarp.tarefa_operacional WHERE tenant_id=@tenant_id AND excluido_em IS NULL AND (responsavel_usuario_id=@user_id OR responsavel_usuario_id IS NULL AND (@sector_id IS NULL OR setor_id=@sector_id)) ORDER BY status, vencimento_em NULLS LAST LIMIT 100;", ct, P("tenant_id", tenantId), P("user_id", userId), P("sector_id", sectorId));
    public Task<IDictionary<string, object?>?> GetTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("SELECT id,codigo,titulo,descricao,status,vencimento_em AS \"vencimentoEm\",responsavel_email AS \"responsavelEmail\" FROM integrarp.tarefa_operacional WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> ClaimTaskAsync(Guid tenantId, Guid id, Guid userId, string? email, CancellationToken ct) => FirstAsync("UPDATE integrarp.tarefa_operacional SET status='em_execucao', responsavel_usuario_id=@user_id, responsavel_email=@email, atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,codigo,titulo,status,responsavel_usuario_id AS \"responsavelUsuarioId\",responsavel_email AS \"responsavelEmail\";", ct, P("tenant_id", tenantId), P("id", id), P("user_id", userId), P("email", email));
    public Task<IDictionary<string, object?>?> CommentTaskAsync(Guid tenantId, Guid id, AddTaskCommentRequest request, Guid userId, CancellationToken ct) => FirstAsync("INSERT INTO integrarp.tarefa_comentario (tenant_id,tarefa_id,author_user_id,texto) SELECT @tenant_id,t.id,@user_id,@text FROM integrarp.tarefa_operacional t WHERE t.tenant_id=@tenant_id AND t.id=@id AND t.excluido_em IS NULL RETURNING id,tarefa_id AS \"taskId\",author_user_id AS \"authorUserId\",texto AS text,criado_em AS \"createdAt\";", ct, P("tenant_id", tenantId), P("id", id), P("user_id", userId), P("text", request.Text.Trim()));
    public Task<IDictionary<string, object?>?> CompleteTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.tarefa_operacional SET status='concluida', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,codigo,titulo,status;", ct, P("tenant_id", tenantId), P("id", id));

    private async Task<IDictionary<string, object?>?> FirstAsync(string sql, CancellationToken ct, params NpgsqlParameter[] p) => (await QueryAsync(sql, ct, p)).FirstOrDefault();
    private async Task<IReadOnlyList<IDictionary<string, object?>>> QueryAsync(string sql, CancellationToken ct, params NpgsqlParameter[] p)
    { await using var c = await connectionFactory.OpenAsync(ct); await using var cmd = c.CreateCommand(); cmd.CommandText = sql; foreach (var x in p) cmd.Parameters.Add(x); var rows = new List<IDictionary<string, object?>>(); await using var reader = await cmd.ExecuteReaderAsync(ct); while (await reader.ReadAsync(ct)) { var row = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase); for (var i=0;i<reader.FieldCount;i++) row[reader.GetName(i)] = await reader.IsDBNullAsync(i, ct) ? null : reader.GetValue(i); rows.Add(row); } return rows; }
    private async Task<IDictionary<string, object?>?> AddOrderItemAsync(Npgsql.NpgsqlConnection c, Npgsql.NpgsqlTransaction tx, Guid tenantId, Guid orderId, AddOrderItemRequest request, CancellationToken ct) => await FirstAsync(c, tx, """
        WITH pr AS (SELECT id,COALESCE(@unit_price,preco_venda,0) AS preco_venda FROM integrarp.produto WHERE tenant_id=@tenant_id AND id=@product_id AND status <> 'inativo' AND excluido_em IS NULL),
        ped AS (SELECT id FROM integrarp.pedido WHERE tenant_id=@tenant_id AND id=@order_id AND status='rascunho' AND excluido_em IS NULL),
        item AS (INSERT INTO integrarp.pedido_item (tenant_id,pedido_id,produto_id,quantidade,valor_unitario,valor_total)
                 SELECT @tenant_id,ped.id,pr.id,@quantity,pr.preco_venda,(@quantity * pr.preco_venda) - @discount FROM pr,ped
                 RETURNING id,pedido_id,quantidade,valor_total)
        SELECT id,pedido_id AS "pedidoId",quantidade,valor_total AS "valorTotal" FROM item;
        """, ct, P("tenant_id", tenantId), P("order_id", orderId), P("product_id", request.ProductId), P("quantity", request.Quantity), P("unit_price", request.UnitPrice), P("discount", request.Discount));

    private async Task<IDictionary<string, object?>?> RecalculateOrderAsync(Npgsql.NpgsqlConnection c, Npgsql.NpgsqlTransaction tx, Guid tenantId, Guid orderId, CancellationToken ct) => await FirstAsync(c, tx, """
        WITH totals AS (SELECT COALESCE(SUM(valor_total),0) total FROM integrarp.pedido_item WHERE tenant_id=@tenant_id AND pedido_id=@order_id AND excluido_em IS NULL)
        UPDATE integrarp.pedido p SET valor_total=totals.total, atualizado_em=now() FROM totals
        WHERE p.tenant_id=@tenant_id AND p.id=@order_id RETURNING p.id,p.numero,p.status,p.valor_total AS "valorTotal";
        """, ct, P("tenant_id", tenantId), P("order_id", orderId));

    private async Task<IDictionary<string, object?>?> FirstAsync(Npgsql.NpgsqlConnection c, Npgsql.NpgsqlTransaction tx, string sql, CancellationToken ct, params NpgsqlParameter[] p) => (await QueryAsync(c, tx, sql, ct, p)).FirstOrDefault();
    private async Task<IReadOnlyList<IDictionary<string, object?>>> QueryAsync(Npgsql.NpgsqlConnection c, Npgsql.NpgsqlTransaction tx, string sql, CancellationToken ct, params NpgsqlParameter[] p)
    { await using var cmd = c.CreateCommand(); cmd.Transaction = tx; cmd.CommandText = sql; foreach (var x in p) cmd.Parameters.Add(x); var rows = new List<IDictionary<string, object?>>(); await using var reader = await cmd.ExecuteReaderAsync(ct); while (await reader.ReadAsync(ct)) { var row = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase); for (var i=0;i<reader.FieldCount;i++) row[reader.GetName(i)] = await reader.IsDBNullAsync(i, ct) ? null : reader.GetValue(i); rows.Add(row); } return rows; }

    private static NpgsqlParameter P(string name, object? value) => new(name, value ?? DBNull.Value);
    private static string Clean(string? value, string fallback) => string.IsNullOrWhiteSpace(value) ? fallback : value.Trim();
}
