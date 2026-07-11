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
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListProductsAsync(Guid tenantId, CancellationToken ct) => QueryAsync("""
        SELECT p.id,p.sku,p.nome,p.status,p.estoque_minimo AS "estoqueMinimo",p.estoque_atual AS "estoqueAtual"
        FROM integrarp.produto p WHERE p.tenant_id=@tenant_id AND p.excluido_em IS NULL ORDER BY p.criado_em,p.sku LIMIT 100;
        """, ct, P("tenant_id", tenantId));
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
    public Task<IDictionary<string, object?>?> RegisterInventoryEntryAsync(Guid tenantId, DemoInventoryEntryRequest r, CancellationToken ct) => FirstAsync("""
        WITH l AS (SELECT id FROM integrarp.estoque_local WHERE codigo='principal' AND tenant_id=@tenant_id), updated AS (UPDATE integrarp.produto SET estoque_atual=estoque_atual+@quantidade, atualizado_em=now() WHERE tenant_id=@tenant_id AND sku=COALESCE(@sku,'DEMO-A') RETURNING id,tenant_id,estoque_atual)
        INSERT INTO integrarp.estoque_movimento (tenant_id,produto_id,local_id,tipo,quantidade,saldo_apos,metadata_json) SELECT updated.tenant_id,updated.id,l.id,'entrada',@quantidade,updated.estoque_atual,'{"origem":"api-v1.12"}'::jsonb FROM updated,l RETURNING id,tipo,quantidade,saldo_apos AS "saldoApos";
        """, ct, P("tenant_id", tenantId), P("sku", r.Sku), P("quantidade", r.Quantidade <= 0 ? 1 : r.Quantidade));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListOrdersAsync(Guid tenantId, CancellationToken ct) => QueryAsync("SELECT p.id,p.numero,p.status,p.valor_total AS \"valorTotal\",c.nome AS cliente FROM integrarp.pedido p LEFT JOIN integrarp.cliente c ON c.id=p.cliente_id AND c.tenant_id=p.tenant_id WHERE p.tenant_id=@tenant_id AND p.excluido_em IS NULL ORDER BY p.criado_em,p.numero LIMIT 100;", ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> ConfirmOrderAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.pedido SET status='confirmado', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,numero,status;", ct, P("tenant_id", tenantId), P("id", id));
    public Task<IReadOnlyList<IDictionary<string, object?>>> ListMyTasksAsync(Guid tenantId, CancellationToken ct) => QueryAsync("SELECT id,codigo,titulo,status,vencimento_em AS \"vencimentoEm\",responsavel_email AS \"responsavelEmail\" FROM integrarp.tarefa_operacional WHERE tenant_id=@tenant_id AND excluido_em IS NULL ORDER BY status, vencimento_em NULLS LAST LIMIT 100;", ct, P("tenant_id", tenantId));
    public Task<IDictionary<string, object?>?> CompleteTaskAsync(Guid tenantId, Guid id, CancellationToken ct) => FirstAsync("UPDATE integrarp.tarefa_operacional SET status='concluida', atualizado_em=now() WHERE tenant_id=@tenant_id AND id=@id AND excluido_em IS NULL RETURNING id,codigo,titulo,status;", ct, P("tenant_id", tenantId), P("id", id));

    private async Task<IDictionary<string, object?>?> FirstAsync(string sql, CancellationToken ct, params NpgsqlParameter[] p) => (await QueryAsync(sql, ct, p)).FirstOrDefault();
    private async Task<IReadOnlyList<IDictionary<string, object?>>> QueryAsync(string sql, CancellationToken ct, params NpgsqlParameter[] p)
    { await using var c = await connectionFactory.OpenAsync(ct); await using var cmd = c.CreateCommand(); cmd.CommandText = sql; foreach (var x in p) cmd.Parameters.Add(x); var rows = new List<IDictionary<string, object?>>(); await using var reader = await cmd.ExecuteReaderAsync(ct); while (await reader.ReadAsync(ct)) { var row = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase); for (var i=0;i<reader.FieldCount;i++) row[reader.GetName(i)] = await reader.IsDBNullAsync(i, ct) ? null : reader.GetValue(i); rows.Add(row); } return rows; }
    private static NpgsqlParameter P(string name, object? value) => new(name, value ?? DBNull.Value);
    private static string Clean(string? value, string fallback) => string.IsNullOrWhiteSpace(value) ? fallback : value.Trim();
}
