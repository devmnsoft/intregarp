namespace IntegraRP.Application.Events;

public sealed record BusinessEvent(Guid TenantId, string OriginType, Guid? OriginId, string ModuleCode, string EventType, string PayloadJson);

public interface IBusinessEventPublisher { Task PublishAsync(BusinessEvent businessEvent, CancellationToken cancellationToken); }
public interface IBusinessEventHandler { string EventType { get; } Task HandleAsync(BusinessEvent businessEvent, CancellationToken cancellationToken); }
public interface IBusinessEventDispatcher { Task DispatchAsync(CancellationToken cancellationToken); }
