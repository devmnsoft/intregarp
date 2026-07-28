using Dapper;
using IntegraRP.Application.Commercial;
using IntegraRP.Application.Common;
using IntegraRP.Contracts.Commercial;
using IntegraRP.Infrastructure.Data;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresNotificationRepository(IDbConnectionFactory connectionFactory) : INotificationRepository
{
    public async Task<NotificationPageDto> ListAsync(Guid tenantId, Guid userId, int page, int pageSize, CancellationToken ct)
    {
        Validate(tenantId, userId); page = Math.Max(1, page);
        using var connection = await connectionFactory.OpenConnectionAsync(ct);
        var items = (await connection.QueryAsync<NotificationDto>(new CommandDefinition("""
            select id Id,tipo Type,titulo Title,mensagem Message,icone Icon,url DeepLink,prioridade Priority,
                   (lida_em is not null) IsRead,criado_em CreatedAt,row_version RowVersion
              from integrarp.notificacao_usuario
             where tenant_id=@tenantId and usuario_id=@userId and (expira_em is null or expira_em>now())
             order by criado_em desc offset @offset limit @limit
            """, new { tenantId, userId, offset = (page - 1) * pageSize, limit = pageSize + 1 }, cancellationToken: ct))).ToList();
        var hasMore = items.Count > pageSize; if (hasMore) items.RemoveAt(items.Count - 1);
        return new NotificationPageDto(items, await GetUnreadCountAsync(tenantId, userId, ct), hasMore);
    }

    public async Task<int> GetUnreadCountAsync(Guid tenantId, Guid userId, CancellationToken ct)
    {
        Validate(tenantId, userId); using var connection = await connectionFactory.OpenConnectionAsync(ct);
        return await connection.QuerySingleAsync<int>(new CommandDefinition("select count(*) from integrarp.notificacao_usuario where tenant_id=@tenantId and usuario_id=@userId and lida_em is null and (expira_em is null or expira_em>now())", new { tenantId, userId }, cancellationToken: ct));
    }

    public async Task<NotificationDto> MarkReadAsync(Guid tenantId, Guid userId, Guid notificationId, CancellationToken ct)
    {
        Validate(tenantId, userId); using var connection = await connectionFactory.OpenConnectionAsync(ct);
        var row = await connection.QuerySingleOrDefaultAsync<NotificationDto>(new CommandDefinition("""
            update integrarp.notificacao_usuario set lida_em=coalesce(lida_em,now()),lida_por_usuario_id=@userId,atualizado_em=now(),row_version=row_version+1
             where tenant_id=@tenantId and usuario_id=@userId and id=@notificationId
             returning id Id,tipo Type,titulo Title,mensagem Message,icone Icon,url DeepLink,prioridade Priority,true IsRead,criado_em CreatedAt,row_version RowVersion
            """, new { tenantId, userId, notificationId }, cancellationToken: ct));
        return row ?? throw new NotFoundException("Notificação não encontrada.");
    }

    public async Task<int> MarkAllReadAsync(Guid tenantId, Guid userId, CancellationToken ct)
    {
        Validate(tenantId, userId); using var connection = await connectionFactory.OpenConnectionAsync(ct);
        return await connection.ExecuteAsync(new CommandDefinition("update integrarp.notificacao_usuario set lida_em=now(),lida_por_usuario_id=@userId,atualizado_em=now(),row_version=row_version+1 where tenant_id=@tenantId and usuario_id=@userId and lida_em is null", new { tenantId, userId }, cancellationToken: ct));
    }

    public async Task<NotificationDto> CreateAsync(Guid tenantId, CreateNotificationRequest request, string correlationId, CancellationToken ct)
    {
        if (tenantId == default || !request.UserId.HasValue || request.UserId.Value == Guid.Empty) throw new UnauthorizedContextException("Tenant e destinatário são obrigatórios.");
        using var connection = await connectionFactory.OpenConnectionAsync(ct);
        return await connection.QuerySingleAsync<NotificationDto>(new CommandDefinition("""
            insert into integrarp.notificacao_usuario(id,tenant_id,usuario_id,tipo,titulo,mensagem,icone,url,prioridade,idempotency_key,correlation_id,criado_em,atualizado_em,row_version)
            values(gen_random_uuid(),@tenantId,@UserId,@Type,@Title,@Message,@Icon,@DeepLink,@Priority,@IdempotencyKey,@correlationId,now(),now(),1)
            on conflict(tenant_id,idempotency_key) where idempotency_key is not null do update set idempotency_key=excluded.idempotency_key
            returning id Id,tipo Type,titulo Title,mensagem Message,icone Icon,url DeepLink,prioridade Priority,(lida_em is not null) IsRead,criado_em CreatedAt,row_version RowVersion
            """, new { tenantId, request.UserId, request.Type, request.Title, request.Message, request.Icon, request.DeepLink, request.Priority, request.IdempotencyKey, correlationId }, cancellationToken: ct));
    }
    private static void Validate(Guid tenantId, Guid userId) { if (tenantId == default || userId == default) throw new UnauthorizedContextException("Contexto autenticado obrigatório."); }
}
