namespace IntegraRP.Worker;

public sealed class Worker(ILogger<Worker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                logger.LogInformation("Worker IntegraRP executando jobs de outbox/SLA/KPI em modo fundação");
                await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
            }
            catch (OperationCanceledException)
            {
                logger.LogInformation("Worker IntegraRP cancelado");
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Erro no ciclo do worker IntegraRP");
            }
        }
    }
}
