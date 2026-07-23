namespace IntegraRP.Worker.Jobs;

public interface ITenantJobSource
{
    IAsyncEnumerable<Guid> GetActiveTenantsAsync(CancellationToken cancellationToken);
}

public interface IWorkerJobLockRepository
{
    Task<bool> TryAcquireAsync(Guid tenantId, string jobName, TimeSpan timeout, string correlationId, CancellationToken cancellationToken);
    Task ReleaseAsync(Guid tenantId, string jobName, string correlationId, CancellationToken cancellationToken);
}

public interface IWorkerDeadLetterRepository
{
    Task StoreAsync(Guid tenantId, string jobName, string reason, string correlationId, CancellationToken cancellationToken);
}

public abstract class TenantJob(ITenantJobSource tenants, IWorkerJobLockRepository locks, IWorkerDeadLetterRepository deadLetters)
{
    protected abstract string JobName { get; }
    protected abstract Task ProcessTenantAsync(Guid tenantId, string correlationId, CancellationToken cancellationToken);

    public async Task ExecuteAsync(CancellationToken cancellationToken)
    {
        await foreach (var tenantId in tenants.GetActiveTenantsAsync(cancellationToken))
        {
            var correlationId = $"worker-{JobName}-{tenantId:N}-{DateTimeOffset.UtcNow:yyyyMMddHHmmss}";
            try
            {
                if (!await locks.TryAcquireAsync(tenantId, JobName, TimeSpan.FromMinutes(5), correlationId, cancellationToken)) continue;
                await ProcessTenantAsync(tenantId, correlationId, cancellationToken);
                await locks.ReleaseAsync(tenantId, JobName, correlationId, cancellationToken);
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                await deadLetters.StoreAsync(tenantId, JobName, ex.Message, correlationId, cancellationToken);
            }
        }
    }
}

public sealed class OutboxJob(ITenantJobSource tenants, IWorkerJobLockRepository locks, IWorkerDeadLetterRepository deadLetters) : TenantJob(tenants, locks, deadLetters)
{
    protected override string JobName => "outbox";
    protected override Task ProcessTenantAsync(Guid tenantId, string correlationId, CancellationToken cancellationToken) => Task.CompletedTask;
}
public sealed class TaskSlaJob(ITenantJobSource tenants, IWorkerJobLockRepository locks, IWorkerDeadLetterRepository deadLetters) : TenantJob(tenants, locks, deadLetters)
{
    protected override string JobName => "task-sla";
    protected override Task ProcessTenantAsync(Guid tenantId, string correlationId, CancellationToken cancellationToken) => Task.CompletedTask;
}
public sealed class DashboardAggregationJob(ITenantJobSource tenants, IWorkerJobLockRepository locks, IWorkerDeadLetterRepository deadLetters) : TenantJob(tenants, locks, deadLetters)
{
    protected override string JobName => "dashboard-aggregation";
    protected override Task ProcessTenantAsync(Guid tenantId, string correlationId, CancellationToken cancellationToken) => Task.CompletedTask;
}
