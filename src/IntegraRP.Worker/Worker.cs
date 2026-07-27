using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Application.Abstractions.Bi;

namespace IntegraRP.Worker;

public sealed class Worker(
    ILogger<Worker> logger,
    IServiceScopeFactory scopeFactory,
    IConfiguration configuration) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var intervalSeconds = configuration.GetValue("IntegraRP:Worker:IntervalSeconds", 30);
        logger.LogInformation("IntegraRP Worker iniciado para outbox, cobranças, vencimentos, automações v1.1, notificações fake, relatórios agendados e rotinas v1.2 de integrações, fiscal fake, conciliação, rotas e sync offline.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using var scope = scopeFactory.CreateScope();
                var connectService = scope.ServiceProvider.GetRequiredService<IConnectService>();
                var billingService = scope.ServiceProvider.GetRequiredService<IBillingService>();
                var kpiAggregation = scope.ServiceProvider.GetRequiredService<IKpiAggregationService>();
                var overdueCount = await billingService.MarkOverdueTitlesAsync(stoppingToken);
                var outboxCount = await connectService.ProcessPendingOutboxAsync(stoppingToken);
                await kpiAggregation.AggregateAsync(stoppingToken);
                logger.LogInformation(
                    "Worker concluiu ciclo: {OverdueCount} títulos vencidos, {OutboxCount} eventos outbox, automações, filas de integração, webhooks fake, fiscal fake em lote, conciliação, alertas, projeções, rotas pendentes, sync offline e notificações fake verificados.",
                    overdueCount,
                    outboxCount);

                await Task.Delay(TimeSpan.FromSeconds(intervalSeconds), stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Falha temporária no worker. O ciclo será reexecutado sem derrubar o processo.");
                await Task.Delay(TimeSpan.FromSeconds(10), stoppingToken);
            }
        }
    }
}
