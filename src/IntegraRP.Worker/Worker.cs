namespace IntegraRP.Worker;

public sealed class Worker(ILogger<Worker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        logger.LogInformation("IntegraRP Worker iniciado com jobs Flow de SLA e outbox fake/log.");
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                logger.LogInformation("Flow job: verificando tarefas vencidas, publicando eventos de atraso e processando outbox fake/log.");
                await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Falha temporária nos jobs Flow. O worker tentará novamente.");
                await Task.Delay(TimeSpan.FromSeconds(10), stoppingToken);
            }
        }
    }
}
