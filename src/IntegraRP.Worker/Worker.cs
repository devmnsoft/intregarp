using IntegraRP.Application.Abstractions.Billing;
using IntegraRP.Application.Abstractions.Connect;
using IntegraRP.Application.Abstractions.Bi;
using IntegraRP.Application.Abstractions.Operations;

namespace IntegraRP.Worker;

public sealed class Worker(
    ILogger<Worker> logger,
    IServiceScopeFactory scopeFactory,
    IConfiguration configuration) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var intervalSeconds = configuration.GetValue("IntegraRP:Worker:IntervalSeconds", 30);
        logger.LogInformation("IntegraRP Worker iniciado para outbox, cobranças, vencimentos e providers fake/log.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using var scope = scopeFactory.CreateScope();
                var connectService = scope.ServiceProvider.GetRequiredService<IConnectService>();
                var billingService = scope.ServiceProvider.GetRequiredService<IBillingService>();
                var kpiAggregation = scope.ServiceProvider.GetRequiredService<IKpiAggregationService>();
                var scoreService = scope.ServiceProvider.GetRequiredService<IOperationalScoreService>();
                var deliveryKpis = scope.ServiceProvider.GetRequiredService<IDeliveryKpiService>();
                var monitoring = scope.ServiceProvider.GetRequiredService<IDeliveryMonitoringService>();

                var overdueCount = await billingService.MarkOverdueTitlesAsync(stoppingToken);
                var outboxCount = await connectService.ProcessPendingOutboxAsync(stoppingToken);
                await kpiAggregation.AggregateAsync(stoppingToken);
                var operationalTenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
                await scoreService.RecalculateAsync(operationalTenantId, stoppingToken);
                await deliveryKpis.RecalculateAsync(operationalTenantId, stoppingToken);
                var deliveryDashboard = await monitoring.GetDashboardAsync(operationalTenantId, stoppingToken);
                if (deliveryDashboard.OcorrenciasAbertas > 0 || deliveryDashboard.EntregasPendentes > 0)
                {
                    logger.LogInformation("Monitoramento operacional: {Pendentes} PODs/entregas pendentes e {Ocorrencias} ocorrências abertas sem derrubar Connect.", deliveryDashboard.EntregasPendentes, deliveryDashboard.OcorrenciasAbertas);
                }

                logger.LogInformation(
                    "Worker concluiu ciclo: {OverdueCount} títulos vencidos, {OutboxCount} eventos outbox e KPIs operacionais recalculados.",
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
