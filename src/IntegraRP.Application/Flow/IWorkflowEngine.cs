using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;

namespace IntegraRP.Application.Flow;

public interface IProcessDefinitionRepository { Task<IReadOnlyList<FlowProcessResponse>> ListAsync(Guid tenantId, CancellationToken cancellationToken); Task<FlowProcessResponse> CreateAsync(Guid tenantId, CreateProcessRequest request, CancellationToken cancellationToken); }
public interface IProcessInstanceRepository { Task<IReadOnlyList<FlowInstanceResponse>> ListInstancesAsync(Guid tenantId, CancellationToken cancellationToken); }
public interface IWorkflowTaskRepository { Task<IReadOnlyList<WorkflowTaskResponse>> ListOpenAsync(Guid tenantId, CancellationToken cancellationToken); }
public interface IWorkflowEngine { Task<FlowInstanceResponse> StartAsync(Guid tenantId, Guid processId, StartProcessRequest request, CancellationToken cancellationToken); Task<WorkflowTaskResponse> CompleteTaskAsync(Guid tenantId, Guid taskId, CompleteTaskRequest request, CancellationToken cancellationToken); }
public interface IProcessPublisher { Task PublishAsync(Guid tenantId, Guid processId, CancellationToken cancellationToken); }
public interface IWorkflowEventDispatcher { Task DispatchAsync(Guid tenantId, string eventType, string payloadJson, CancellationToken cancellationToken); }
public interface IWorkflowGatewayEvaluator { bool Evaluate(string? condition, IReadOnlyDictionary<string, object?> variables); }
