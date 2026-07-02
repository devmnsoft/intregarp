using IntegraRP.Contracts.Flow;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
[Tags("Flow Dashboard")]
public sealed class FlowDashboardController(ILogger<FlowDashboardController> logger) : IntegraControllerBase
{
    [HttpGet("api/flow/dashboard")]
    public IActionResult Dashboard() { try { return Ok(new FlowDashboardSummaryResponse(1, 0, 0, 0, 0)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Dashboard)); } }
    [HttpGet("api/flow/tasks/overdue")]
    public IActionResult OverdueTasks() { try { return Ok(Array.Empty<OverdueTaskResponse>()); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(OverdueTasks)); } }
    [HttpGet("api/flow/instances/overdue")]
    public IActionResult OverdueInstances() { try { return Ok(Array.Empty<OverdueProcessResponse>()); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(OverdueInstances)); } }
}
