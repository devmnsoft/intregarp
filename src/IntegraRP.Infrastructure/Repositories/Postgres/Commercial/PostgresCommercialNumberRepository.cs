using Dapper;
using IntegraRP.Application.Commercial;
using IntegraRP.Infrastructure.Data;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresCommercialNumberRepository(IDbConnectionFactory connectionFactory) : ICommercialNumberRepository
{
    public async Task<string> NextAsync(Guid tenantId, CommercialDocumentType documentType, int year, CancellationToken cancellationToken)
    {
        var type = documentType == CommercialDocumentType.Quote ? "orcamento" : "pedido";
        var prefix = documentType == CommercialDocumentType.Quote ? "ORC" : "PED";
        using var connection = await connectionFactory.OpenConnectionAsync(cancellationToken);
        using var transaction = connection.BeginTransaction();
        var number = await connection.QuerySingleAsync<long>(new CommandDefinition("""
            insert into integrarp.numeracao_comercial (tenant_id, tipo, ano, proximo_numero, criado_em, atualizado_em)
            values (@tenantId, @type, @year, 2, now(), now())
            on conflict (tenant_id, tipo, ano) do update
               set proximo_numero = integrarp.numeracao_comercial.proximo_numero + 1,
                   atualizado_em = now()
            returning proximo_numero - 1
            """, new { tenantId, type, year }, transaction, cancellationToken: cancellationToken));
        transaction.Commit();
        return $"{prefix}-{year:0000}-{number:000000}";
    }
}
