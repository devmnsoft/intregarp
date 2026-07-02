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

                var overdueCount = await billingService.MarkOverdueTitlesAsync(stoppingToken);
                var outboxCount = await connectService.ProcessPendingOutboxAsync(stoppingToken);
                await kpiAggregation.AggregateAsync(stoppingToken);
                await scoreService.RecalculateAsync(Guid.Parse("11111111-1111-1111-1111-111111111111"), stoppingToken);

                logger.LogInformation(
                    "Worker concluiu ciclo: {OverdueCount} títulos vencidos marcados e {OutboxCount} eventos outbox processados.",
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
