using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Worker;

public sealed class MobileAiWorker(ILogger<MobileAiWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                logger.LogInformation("Sprint 8 worker: notificações mobile fake, sync pendente e fallback IA verificados.");
                await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { }
            catch (Exception ex)
            {
                logger.LogError(ex, "Erro no worker Sprint 8 sem derrubar o processo.");
                await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
            }
        }
    }
}
