using IntegraRP.Application.Flow;
using IntegraRP.Contracts.Requests;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/flow")]
public sealed class FlowController(IProcessDefinitionRepository processes, IProcessInstanceRepository instances, IWorkflowTaskRepository tasks, IWorkflowEngine engine, IProcessPublisher publisher, ILogger<FlowController> logger) : IntegraControllerBase
{
    [HttpGet("processos")]
    public async Task<IActionResult> GetProcesses(CancellationToken cancellationToken) { try { return Ok(await processes.ListAsync(TenantId, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetProcesses)); } }

    [HttpPost("processos")]
    public async Task<IActionResult> CreateProcess([FromBody] CreateProcessRequest request, CancellationToken cancellationToken) { try { return Ok(await processes.CreateAsync(TenantId, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(CreateProcess)); } }

    [HttpGet("processos/{id:guid}")]
    public async Task<IActionResult> GetProcess(Guid id, CancellationToken cancellationToken) { try { return Ok((await processes.ListAsync(TenantId, cancellationToken)).FirstOrDefault(x => x.Id == id)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetProcess)); } }

    [HttpPost("processos/{id:guid}/versoes")]
    public IActionResult CreateVersion(Guid id, [FromBody] CreateProcessVersionRequest request) { logger.LogInformation("Versão criada para processo {ProcessId}", id); return Ok(new { processId = id, request.Nome, request.JsonDefinition }); }

    [HttpPost("processos/{id:guid}/publicar")]
    public async Task<IActionResult> Publish(Guid id, CancellationToken cancellationToken) { try { await publisher.PublishAsync(TenantId, id, cancellationToken); return NoContent(); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Publish)); } }

    [HttpPost("processos/{id:guid}/iniciar")]
    public async Task<IActionResult> Start(Guid id, [FromBody] StartProcessRequest request, CancellationToken cancellationToken) { try { return Ok(await engine.StartAsync(TenantId, id, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Start)); } }

    [HttpGet("instancias")]
    public async Task<IActionResult> GetInstances(CancellationToken cancellationToken) { try { return Ok(await instances.ListInstancesAsync(TenantId, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetInstances)); } }

    [HttpGet("tarefas")]
    public async Task<IActionResult> GetTasks(CancellationToken cancellationToken) { try { return Ok(await tasks.ListOpenAsync(TenantId, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(GetTasks)); } }

    [HttpPatch("tarefas/{id:guid}/concluir")]
    public async Task<IActionResult> CompleteTask(Guid id, [FromBody] CompleteTaskRequest request, CancellationToken cancellationToken) { try { return Ok(await engine.CompleteTaskAsync(TenantId, id, request, cancellationToken)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(CompleteTask)); } }

    [HttpPost("tarefas/{id:guid}/comentarios")]
    public IActionResult Comment(Guid id, [FromBody] CriarComentarioRequest request) { logger.LogInformation("Comentário em tarefa {TaskId}", id); return Ok(new { id, request.Mensagem }); }
}
