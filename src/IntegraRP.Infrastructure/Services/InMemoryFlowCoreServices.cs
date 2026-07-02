using System.Text.Json;
using IntegraRP.Application.Abstractions.Flow;
using IntegraRP.Contracts.Flow;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Services;

public sealed class InMemoryFlowCoreServices(ILogger<InMemoryFlowCoreServices> logger) :
    IProcessDefinitionRepository,
    IProcessVersionRepository,
    IProcessElementRepository,
    IProcessTransitionRepository,
    IProcessInstanceRepository,
    IWorkflowTaskRepository,
    IWorkflowAuditRepository,
    IBusinessEventRepository,
    IOutboxEventRepository,
    IWorkflowEngine,
    IWorkflowGatewayEvaluator,
    IWorkflowTaskFactory,
    IWorkflowEventPublisher,
    IWorkflowSlaCalculator,
    IWorkflowCodeGenerator,
    IUnitOfWork
{
    private readonly List<ProcessDefinitionResponse> definitions = [new(Guid.Parse("11111111-1111-1111-1111-111111111111"), Guid.Parse("11111111-1111-1111-1111-111111111111"), "pedido_ao_pos_venda", "Pedido ao Pós-venda", "publicado", Guid.Parse("22222222-2222-2222-2222-222222222222"))];
    private readonly List<ProcessVersionResponse> versions = [new(Guid.Parse("22222222-2222-2222-2222-222222222222"), Guid.Parse("11111111-1111-1111-1111-111111111111"), 1, "publicada", DateTimeOffset.UtcNow)];
    private readonly List<ProcessElementResponse> elements = [];
    private readonly List<(Guid VersionId, ProcessTransitionResponse Transition)> transitions = [];
    private readonly List<ProcessInstanceResponse> instances = [];
    private readonly List<WorkflowTaskResponse> tasks = [];
    private readonly List<WorkflowAuditEventResponse> audit = [];

    public Task<IReadOnlyList<ProcessDefinitionResponse>> ListAsync(Guid tenantId, int page, int pageSize, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProcessDefinitionResponse>>(definitions.Where(x => x.TenantId == tenantId).Skip((page - 1) * pageSize).Take(pageSize).ToArray());
    public Task<ProcessDefinitionResponse?> GetAsync(Guid tenantId, Guid id, CancellationToken ct) => Task.FromResult(definitions.FirstOrDefault(x => x.TenantId == tenantId && x.Id == id));
    public Task<ProcessDefinitionResponse> CreateAsync(Guid tenantId, CreateProcessDefinitionRequest request, CancellationToken ct) { var item = new ProcessDefinitionResponse(Guid.NewGuid(), tenantId, request.Codigo, request.Nome, "rascunho", null); definitions.Add(item); _ = AddAsync(tenantId, "flow.process.definition.created", request.Codigo, ct); return Task.FromResult(item); }
    public Task<ProcessDefinitionResponse> UpdateAsync(Guid tenantId, Guid id, UpdateProcessDefinitionRequest request, CancellationToken ct) { var old = definitions.First(x => x.TenantId == tenantId && x.Id == id); var item = old with { Nome = request.Nome }; definitions.Remove(old); definitions.Add(item); return Task.FromResult(item); }
    public Task ArchiveAsync(Guid tenantId, Guid id, CancellationToken ct) { var old = definitions.First(x => x.TenantId == tenantId && x.Id == id); definitions.Remove(old); definitions.Add(old with { Status = "arquivado" }); return Task.CompletedTask; }
    public Task<ProcessVersionResponse> CreateDraftAsync(Guid tenantId, Guid definitionId, CancellationToken ct) { var item = new ProcessVersionResponse(Guid.NewGuid(), definitionId, versions.Count(x => x.DefinitionId == definitionId) + 1, "rascunho", null); versions.Add(item); return Task.FromResult(item); }
    public Task<ProcessDiagramResponse?> GetDiagramAsync(Guid tenantId, Guid versionId, CancellationToken ct) { var version = versions.FirstOrDefault(x => x.Id == versionId); return Task.FromResult(version is null ? null : new ProcessDiagramResponse(version, elements, transitions.Where(x => x.VersionId == versionId).Select(x => x.Transition).ToArray())); }
    public Task<ProcessVersionResponse> PublishAsync(Guid tenantId, Guid versionId, Guid? userId, CancellationToken ct) { var old = versions.First(x => x.Id == versionId); var item = old with { Status = "publicada", PublicadoEm = DateTimeOffset.UtcNow }; versions.Remove(old); versions.Add(item); definitions.RemoveAll(x => x.Id == old.DefinitionId); definitions.Add(new ProcessDefinitionResponse(old.DefinitionId, tenantId, "pedido_ao_pos_venda", "Pedido ao Pós-venda", "publicado", versionId)); return Task.FromResult(item); }
    public Task<ProcessElementResponse> AddAsync(Guid tenantId, Guid versionId, AddProcessElementRequest request, CancellationToken ct) { var item = new ProcessElementResponse(Guid.NewGuid(), request.Codigo, request.Nome, request.Tipo, request.SlaMinutos); elements.Add(item); return Task.FromResult(item); }
    public Task<ProcessElementResponse> UpdateAsync(Guid tenantId, Guid versionId, Guid elementId, UpdateProcessElementRequest request, CancellationToken ct) { var old = elements.First(x => x.Id == elementId); var item = old with { Nome = request.Nome, SlaMinutos = request.SlaMinutos }; elements.Remove(old); elements.Add(item); return Task.FromResult(item); }
    public Task RemoveAsync(Guid tenantId, Guid versionId, Guid elementId, CancellationToken ct) { elements.RemoveAll(x => x.Id == elementId); return Task.CompletedTask; }
    public Task<ProcessTransitionResponse> AddAsync(Guid tenantId, Guid versionId, AddProcessTransitionRequest request, CancellationToken ct) { var item = new ProcessTransitionResponse(Guid.NewGuid(), request.ElementoOrigemId, request.ElementoDestinoId, request.Codigo, request.CondicaoTipo, request.CondicaoJson ?? "{}"); transitions.Add((versionId, item)); return Task.FromResult(item); }
    public Task<ProcessTransitionResponse> UpdateAsync(Guid tenantId, Guid versionId, Guid transitionId, UpdateProcessTransitionRequest request, CancellationToken ct) { var old = transitions.First(x => x.Transition.Id == transitionId); transitions.Remove(old); var item = old.Transition with { CondicaoTipo = request.CondicaoTipo, CondicaoJson = request.CondicaoJson ?? "{}" }; transitions.Add((versionId, item)); return Task.FromResult(item); }
    public Task RemoveAsync(Guid tenantId, Guid versionId, Guid transitionId, CancellationToken ct) { transitions.RemoveAll(x => x.Transition.Id == transitionId); return Task.CompletedTask; }
    public Task<IReadOnlyList<ProcessInstanceResponse>> ListAsync(Guid tenantId, string? status, int page, int pageSize, CancellationToken ct) => Task.FromResult<IReadOnlyList<ProcessInstanceResponse>>(instances.Where(x => status is null || x.Status == status).ToArray());
    public Task<ProcessInstanceDetailResponse?> GetAsync(Guid tenantId, Guid id, CancellationToken ct) { var inst = instances.FirstOrDefault(x => x.Id == id); return Task.FromResult(inst is null ? null : new ProcessInstanceDetailResponse(inst, tasks.Where(x => x.ProcessInstanceId == id).ToArray(), audit)); }
    public Task CancelAsync(Guid tenantId, Guid id, string reason, CancellationToken ct) { var old = instances.First(x => x.Id == id); instances.Remove(old); instances.Add(old with { Status = "cancelado" }); return Task.CompletedTask; }
    public Task<IReadOnlyList<WorkflowTaskResponse>> ListAsync(Guid tenantId, Guid? userId, Guid? departmentId, Guid? processId, int page, int pageSize, CancellationToken ct) => Task.FromResult<IReadOnlyList<WorkflowTaskResponse>>(tasks.Where(x => processId is null || x.ProcessInstanceId == processId).ToArray());
    public Task<WorkflowTaskDetailResponse?> GetAsync(Guid tenantId, Guid id, CancellationToken ct) { var task = tasks.FirstOrDefault(x => x.Id == id); return Task.FromResult(task is null ? null : new WorkflowTaskDetailResponse(task, [], [])); }
    public Task<WorkflowTaskResponse> AssumeAsync(Guid tenantId, Guid id, Guid userId, CancellationToken ct) { var old = tasks.First(x => x.Id == id); var item = old with { Status = "atribuida", UsuarioResponsavelId = userId }; tasks.Remove(old); tasks.Add(item); return Task.FromResult(item); }
    public Task<WorkflowTaskResponse> AssignAsync(Guid tenantId, Guid id, AssignWorkflowTaskRequest request, CancellationToken ct) => AssumeAsync(tenantId, id, request.UsuarioResponsavelId, ct);
    public Task<WorkflowTaskResponse> CancelAsync(Guid tenantId, Guid id, Guid? userId, CancellationToken ct) { var old = tasks.First(x => x.Id == id); var item = old with { Status = "cancelada" }; tasks.Remove(old); tasks.Add(item); return Task.FromResult(item); }
    public Task AddCommentAsync(Guid tenantId, Guid id, AddWorkflowTaskCommentRequest request, CancellationToken ct) => Task.CompletedTask;
    public Task AddAttachmentAsync(Guid tenantId, Guid id, AddWorkflowTaskAttachmentRequest request, CancellationToken ct) => Task.CompletedTask;
    public Task<IReadOnlyList<WorkflowAuditEventResponse>> ListByInstanceAsync(Guid tenantId, Guid instanceId, CancellationToken ct) => Task.FromResult<IReadOnlyList<WorkflowAuditEventResponse>>(audit);
    public Task AddAsync(Guid tenantId, string eventType, string description, CancellationToken ct) { audit.Add(new(Guid.NewGuid(), eventType, description, DateTimeOffset.UtcNow)); logger.LogInformation("Flow audit {EventType}: {Description}", eventType, description); return Task.CompletedTask; }
    public Task AddAsync(Guid tenantId, string eventType, string channel, string payloadJson, CancellationToken ct) { logger.LogInformation("Flow outbox {EventType} via {Channel}: {Payload}", eventType, channel, payloadJson); return Task.CompletedTask; }
    public Task<StartProcessInstanceResponse> StartProcessInstanceAsync(Guid tenantId, Guid definitionId, StartProcessInstanceRequest request, CancellationToken ct) { var inst = new ProcessInstanceResponse(Guid.NewGuid(), definitionId, NewProcessInstanceCode(), request.Titulo, "aguardando_tarefa", DateTimeOffset.UtcNow, null); instances.Add(inst); var task = new WorkflowTaskResponse(Guid.NewGuid(), inst.Id, NewTaskCode(), "Validar cliente", "aberta", "media", null, null, DateTimeOffset.UtcNow.AddMinutes(60)); tasks.Add(task); _ = AddAsync(tenantId, "flow.process.started", inst.Codigo, ct); _ = PublishAsync(tenantId, "flow.task.created", task, ct); return Task.FromResult(new StartProcessInstanceResponse(inst.Id, inst.Codigo, inst.Status, task.Id)); }
    public Task<WorkflowTaskResponse> CompleteWorkflowTaskAsync(Guid tenantId, Guid taskId, CompleteWorkflowTaskRequest request, CancellationToken ct) { var old = tasks.First(x => x.Id == taskId); if (old.Status == "concluida") throw new InvalidOperationException("Tarefa concluída não pode ser concluída novamente."); var item = old with { Status = "concluida" }; tasks.Remove(old); tasks.Add(item); _ = AddAsync(tenantId, "flow.task.completed", item.Codigo, ct); return Task.FromResult(item); }
    public Task<ProcessInstanceResponse> AdvanceProcessInstanceAsync(Guid tenantId, Guid instanceId, CancellationToken ct) => Task.FromResult(instances.First(x => x.Id == instanceId));
    public bool Evaluate(string conditionType, string conditionJson, IReadOnlyDictionary<string, object?> variables) { if (conditionType == "always") return true; using var doc = JsonDocument.Parse(string.IsNullOrWhiteSpace(conditionJson) ? "{}" : conditionJson); var variable = doc.RootElement.TryGetProperty("variable", out var v) ? v.GetString() : null; return variable is not null && variables.ContainsKey(variable); }
    public WorkflowTaskResponse Create(Guid tenantId, Guid instanceId, ProcessElementResponse element) => new(Guid.NewGuid(), instanceId, NewTaskCode(), element.Nome, "aberta", "media", null, null, Calculate(DateTimeOffset.UtcNow, element.SlaMinutos));
    public Task PublishAsync(Guid tenantId, string eventType, object payload, CancellationToken ct) { logger.LogInformation("Flow event {EventType}: {Payload}", eventType, JsonSerializer.Serialize(payload)); return Task.CompletedTask; }
    public DateTimeOffset? Calculate(DateTimeOffset start, int? slaMinutes) => slaMinutes is null ? null : start.AddMinutes(slaMinutes.Value);
    public string NewProcessInstanceCode() => $"FLOW-{DateTimeOffset.UtcNow:yyyyMMddHHmmss}";
    public string NewTaskCode() => $"TASK-{Guid.NewGuid():N}"[..18];
    public Task ExecuteAsync(Func<CancellationToken, Task> action, CancellationToken ct) => action(ct);
}
