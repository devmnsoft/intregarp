using Dapper;
using IntegraRP.Application.Onboarding;
using IntegraRP.Contracts.Onboarding;
using IntegraRP.Infrastructure.Data;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresOnboardingProgressQuery(IDbConnectionFactory connectionFactory) : IOnboardingProgressQuery
{
    public async Task<OnboardingFactsDto> GetFactsAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken)
    {
        if (tenantId == Guid.Empty || userId == Guid.Empty) throw new UnauthorizedAccessException("Contexto autenticado obrigatório.");
        using var connection = await connectionFactory.OpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleAsync<OnboardingFactsDto>(new CommandDefinition("""
            select
              exists(select 1 from integrarp.usuario_preferencia where tenant_id=@tenantId and usuario_id=@userId and chave='organization.confirmed') as OrganizationConfirmed,
              exists(select 1 from integrarp.setor where tenant_id=@tenantId and status='ativo' and excluido_em is null) as SectorsReviewed,
              exists(select 1 from integrarp.cliente where tenant_id=@tenantId and status='ativo' and excluido_em is null) as FirstCustomer,
              exists(select 1 from integrarp.produto_categoria where tenant_id=@tenantId and status='ativo' and excluido_em is null) as FirstCategory,
              exists(select 1 from integrarp.produto where tenant_id=@tenantId and status='ativo' and categoria_id is not null and excluido_em is null) as FirstProduct,
              exists(select 1 from integrarp.estoque_saldo where tenant_id=@tenantId and saldo_fisico>0) as FirstInventory,
              exists(select 1 from integrarp.pedido where tenant_id=@tenantId and excluido_em is null) as FirstOrder,
              exists(select 1 from integrarp.tarefa_operacional where tenant_id=@tenantId and status='concluida' and (responsavel_usuario_id=@userId or responsavel_usuario_id is null)) as FirstTask
            """, new { tenantId, userId }, cancellationToken: cancellationToken));
    }
}
