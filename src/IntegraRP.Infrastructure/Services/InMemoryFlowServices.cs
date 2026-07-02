using IntegraRP.Application.Flow;
using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Services;

public sealed class InMemoryFlowServices(ILogger<InMemoryFlowServices> logger) :
    IProcessDefinitionRepository,
    IProcessInstanceRepository,
    IWorkflowTaskRepository,
    IWorkflowEngine,
    IProcessPublisher,
    IWorkflowEventDispatcher,
    IWorkflowGatewayEvaluator
{
    private readonly List<FlowProcessResponse> processes =
    [
        new FlowProcessResponse(Guid.Parse("11111111-1111-1111-1111-111111111111"), "Pedido ao Pós-venda", "pedido-pos-venda", "publicado", ["Pedido recebido", "Validar cliente", "Crédito aprovado?", "Reservar estoque", "Pós-venda"])
    ];
    private readonly List<FlowInstanceResponse> instances = [];
    private readonly List<WorkflowTaskResponse> tasks = [];

    public Task<IReadOnlyList<FlowProcessResponse>> ListAsync(Guid tenantId, CancellationToken cancellationToken) => Task.FromResult<IReadOnlyList<FlowProcessResponse>>(processes);

    public Task<FlowProcessResponse> CreateAsync(Guid tenantId, CreateProcessRequest request, CancellationToken cancellationToken)
    {
        var process = new FlowProcessResponse(Guid.NewGuid(), request.Nome, request.Codigo, "rascunho", request.Etapas.Select(x => x.Nome).ToArray());
        processes.Add(process);
        logger.LogInformation("Processo {ProcessCode} criado para tenant {TenantId}", request.Codigo, tenantId);
        return Task.FromResult(process);
    }

    public Task<IReadOnlyList<FlowInstanceResponse>> ListInstancesAsync(Guid tenantId, CancellationToken cancellationToken) => Task.FromResult<IReadOnlyList<FlowInstanceResponse>>(instances);

    public Task<IReadOnlyList<WorkflowTaskResponse>> ListOpenAsync(Guid tenantId, CancellationToken cancellationToken) => Task.FromResult<IReadOnlyList<WorkflowTaskResponse>>(tasks.Where(x => x.Status != "Completed").ToArray());

    public Task<FlowInstanceResponse> StartAsync(Guid tenantId, Guid processId, StartProcessRequest request, CancellationToken cancellationToken)
    {
        var instance = new FlowInstanceResponse(Guid.NewGuid(), processId, "Running", DateTimeOffset.UtcNow);
        instances.Add(instance);
        tasks.Add(new WorkflowTaskResponse(Guid.NewGuid(), "Validar cliente", "Open", "Normal", "Vendas"));
        logger.LogInformation("Instância {InstanceId} iniciada para processo {ProcessId}", instance.Id, processId);
        return Task.FromResult(instance);
    }

    public Task<WorkflowTaskResponse> CompleteTaskAsync(Guid tenantId, Guid taskId, CompleteTaskRequest request, CancellationToken cancellationToken)
    {
        var existing = tasks.FirstOrDefault(x => x.Id == taskId) ?? new WorkflowTaskResponse(taskId, "Tarefa", "Open", "Normal", "Operação");
        var completed = existing with { Status = "Completed" };
        tasks.RemoveAll(x => x.Id == taskId);
        tasks.Add(completed);
        logger.LogInformation("Tarefa {TaskId} concluída com resultado {Result}", taskId, request.Resultado);
        return Task.FromResult(completed);
    }

    public Task PublishAsync(Guid tenantId, Guid processId, CancellationToken cancellationToken)
    {
        logger.LogInformation("Processo {ProcessId} publicado para tenant {TenantId}", processId, tenantId);
        return Task.CompletedTask;
    }

    public Task DispatchAsync(Guid tenantId, string eventType, string payloadJson, CancellationToken cancellationToken)
    {
        logger.LogInformation("Evento BPMN {EventType} despachado para tenant {TenantId}", eventType, tenantId);
        return Task.CompletedTask;
    }

    public bool Evaluate(string? condition, IReadOnlyDictionary<string, object?> variables) => string.IsNullOrWhiteSpace(condition) || variables.ContainsKey(condition);
}
