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
    public Task<IDictionary<string, object?>?> CreateOrderAsync(Guid tenantId, CancellationToken ct) => FirstAsync("""
        WITH c AS (SELECT id FROM integrarp.cliente WHERE tenant_id=@tenant_id AND excluido_em IS NULL ORDER BY criado_em LIMIT 1)
        INSERT INTO integrarp.pedido (tenant_id,cliente_id,numero,status,valor_total,metadata_json)
        SELECT @tenant_id,c.id,'PED-'||to_char(now(),'YYYYMMDDHH24MISSMS'),'rascunho',0,'{"origem":"api-v1.13"}'::jsonb FROM c
        RETURNING id,numero,status,valor_total AS "valorTotal";
        """, ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> AddOrderItemAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("WITH pr AS (SELECT id,preco_venda FROM integrarp.produto WHERE tenant_id=@tenant_id AND excluido_em IS NULL ORDER BY criado_em LIMIT 1), item AS (INSERT INTO integrarp.pedido_item (tenant_id,pedido_id,produto_id,quantidade,valor_unitario,valor_total) SELECT @tenant_id,@id,pr.id,1,COALESCE(pr.preco_venda,0),COALESCE(pr.preco_venda,0) FROM pr RETURNING id,pedido_id,quantidade,valor_total) UPDATE integrarp.pedido p SET valor_total=p.valor_total + item.valor_total, atualizado_em=now() FROM item WHERE p.id=item.pedido_id AND p.tenant_id=@tenant_id RETURNING item.id,item.pedido_id AS \"pedidoId\",item.quantidade,item.valor_total AS \"valorTotal\";", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> RemoveOrderItemAsync(Guid tenantId, Guid id, Guid itemId, CancellationToken ct) => FirstAsync("UPDATE integrarp.pedido_item SET excluido_em=now(), atualizado_em=now() WHERE tenant_id=@tenant_id AND pedido_id=@id AND id=@item_id AND excluido_em IS NULL RETURNING id,pedido_id AS \"pedidoId\",excluido_em AS \"excluidoEm\";", ct, P("tenant_id", tenantId), P("id", id), P("item_id", itemId));
    public Task<IDictionary<string, object?>?> ConfirmOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.pedido SET status='confirmado', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,numero,status;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> CancelOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.pedido SET status='cancelado', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,numero,status;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListMyTasksAsync(Guid tenantId, CancellationToken ct) => QueryAsync("SELECT id,codigo,titulo,status,vencimento_em AS \"vencimentoEm\",responsavel_email AS \"responsavelEmail\" FROM integrarp.tarefa_operacional WHERE tenant_id=@tenant_id AND excluido_em IS NULL ORDER BY status, vencimento_em NULLS LAST LIMIT 100;", ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> GetTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("SELECT id,codigo,titulo,descricao,status,vencimento_em AS \"vencimentoEm\",responsavel_email AS \"responsavelEmail\" FROM integrarp.tarefa_operacional WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> ClaimTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.tarefa_operacional SET status='em_execucao', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,codigo,titulo,status;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> CommentTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.tarefa_operacional SET metadata_json = COALESCE(metadata_json,'{}'::jsonb) || jsonb_build_object('ultimoComentario','Comentário registrado pela API v1.13'), atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,codigo,titulo,status,metadata_json AS metadata;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IDictionary<string, object?>?> CompleteTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.tarefa_operacional SET status='concluida', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,codigo,titulo,status;", ct, P("tenant_id", tenantId), P("id", id));

    private async Task<IDictionary<string, object?>?> FirstAsync(string sql, CancellationToken ct, params NpgsqlParameter[] p) => (await QueryAsync(sql, ct, p)).FirstOrDefault();
    private async Task<IReadOnlyList<IDictionary<string, object?>>> QueryAsync(string sql, CancellationToken ct, params NpgsqlParameter[] p)
    { await using var c = await connectionFactory.OpenAsync(ct); await using var cmd = c.CreateCommand(); cmd.CommandText = sql; foreach (var x in p) cmd.Parameters.Add(x); var rows = new List<IDictionary<string, object?>>(); await using var reader = await cmd.ExecuteReaderAsync(ct); while (await reader.ReadAsync(ct)) { var row = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase); for (var i=0;i<reader.FieldCount;i++) row[reader.GetName(i)] = await reader.IsDBNullAsync(i, ct) ? null : reader.GetValue(i); rows.Add(row); } return rows; }
    private static NpgsqlParameter P(string name, object? value) => new(name, value ?? DBNull.Value);
    private static string Clean(string? value, string fallback) => string.IsNullOrWhiteSpace(value) ? fallback : value.Trim();
}
