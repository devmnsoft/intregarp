using Dapper;
using IntegraRP.Infrastructure.Data;

namespace IntegraRP.Worker;

public sealed class Worker(
    ILogger<Worker> logger,
    IDbConnectionFactory connectionFactory,
    IConfiguration configuration) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var interval = TimeSpan.FromSeconds(Math.Max(5, configuration.GetValue("IntegraRP:Worker:IntervalSeconds", 30)));
        logger.LogInformation("IntegraRP Worker iniciado para outbox, SLA de tarefas e notificações persistidas.");

        using var timer = new PeriodicTimer(interval);
        do
        {
            try
            {
                using var connection = await connectionFactory.OpenConnectionAsync(stoppingToken);
                using var transaction = connection.BeginTransaction();
                var expired = await connection.ExecuteAsync(new CommandDefinition("""
                    with changed as (
                      update integrarp.tarefa_operacional
                         set prioridade='urgente', atualizado_em=now(), row_version=row_version+1
                       where vencimento_em < now() and status not in ('concluida','cancelada') and prioridade <> 'urgente'
                       returning tenant_id, responsavel_usuario_id usuario_id, id
                    )
                    insert into integrarp.notificacao_usuario(id,tenant_id,usuario_id,tipo,titulo,mensagem,icone,url,prioridade,correlation_id,criado_em,row_version)
                    select gen_random_uuid(),tenant_id,usuario_id,'tarefa.vencida','Tarefa vencida','Uma tarefa ultrapassou o prazo e precisa de atenção.','clock-history','/tasks/my/'||id,'urgente','worker-sla-'||id,now(),1
                      from changed where usuario_id is not null
                    """, transaction: transaction, cancellationToken: stoppingToken));
                var outbox = await connection.ExecuteAsync(new CommandDefinition("""
                    with batch as (
                      select id,tenant_id,tipo,payload_json,correlation_id from integrarp.outbox_evento
                       where status='pendente' and coalesce(proxima_tentativa_em,now()) <= now()
                         and tipo in ('pedido.confirmado','pedido.separado','tarefa.criada','tarefa.concluida','estoque.movimentado')
                       order by criado_em for update skip locked limit 100
                    ), handled as (
                      insert into integrarp.outbox_execucao_handler
                        (tenant_id,evento_id,handler,correlation_id,executado_em)
                      select tenant_id,id,case tipo
                        when 'pedido.confirmado' then 'PedidoConfirmadoHandler'
                        when 'pedido.separado' then 'PedidoSeparadoHandler'
                        when 'tarefa.criada' then 'TarefaCriadaHandler'
                        when 'tarefa.concluida' then 'TarefaConcluidaHandler'
                        when 'estoque.movimentado' then 'EstoqueMovimentadoHandler' end,correlation_id,now()
                        from batch
                      on conflict (tenant_id,evento_id) do nothing
                      returning evento_id
                    )
                    update integrarp.outbox_evento o set status='processado',processado_em=now(),atualizado_em=now()
                      from handled where o.id=handled.evento_id
                    """, transaction: transaction, cancellationToken: stoppingToken));
                transaction.Commit();
                logger.LogInformation("Ciclo persistido concluído: {ExpiredTasks} tarefas sinalizadas e {OutboxEvents} eventos processados.", expired, outbox);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { break; }
            catch (Exception exception)
            {
                logger.LogError(exception, "Falha no ciclo persistido; o próximo ciclo continuará normalmente.");
            }
        } while (await timer.WaitForNextTickAsync(stoppingToken));
    }
}
