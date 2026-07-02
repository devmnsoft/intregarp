using IntegraRP.Application.Abstractions.Mobile;
using IntegraRP.Contracts.Mobile;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Mobile;

[ApiController]
[Route("api/mobile/auth")]
public sealed class MobileAuthController(IMobileDeviceRepository devices, ILogger<MobileAuthController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{
    [AllowAnonymous]
    [HttpPost("login")]
    public IActionResult Login([FromBody] MobileLoginRequest request) { try { return Ok(new MobileLoginResponse("demo-mobile-token", "demo-refresh", TenantId, Guid.NewGuid(), request.Email, ["mobile.tasks.visualizar", "ai.chat.usar", "ai.tool.order_status"])); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Login)); } }
    [HttpPost("refresh")] public IActionResult Refresh() => Ok(new { accessToken = "demo-mobile-token" });
    [HttpPost("logout")] public IActionResult Logout() => Ok();
    [HttpGet("me")] public IActionResult Me() => Ok(new MobileCurrentUserResponse(TenantId, Guid.NewGuid(), "Usuário Mobile", "mobile@integrarp.local", ["mobile.tasks.visualizar"]));
    [HttpPost("/api/mobile/devices/register")] public async Task<IActionResult> Register([FromBody] RegisterMobileDeviceRequest request, CancellationToken ct) { try { return Ok(new { id = await devices.RegisterAsync(TenantId, Guid.NewGuid(), request, ct) }); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Register)); } }
}

[ApiController, Route("api/mobile/dashboard")]
public sealed class MobileDashboardController(IMobileDashboardService dashboard, ILogger<MobileDashboardController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpGet] public async Task<IActionResult> Get(CancellationToken ct) { try { return Ok(await dashboard.GetAsync(TenantId, Guid.NewGuid(), ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } } }

[ApiController, Route("api/mobile/tasks")]
public sealed class MobileTasksController(IMobileTaskRepository tasks, IMobileTaskExecutionService execution, IMobileEvidenceRepository evidence, IMobileApprovalService approvals, ILogger<MobileTasksController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List([FromQuery] string? filtro, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken ct = default) { try { return Ok(await tasks.ListMyTasksAsync(TenantId, Guid.NewGuid(), filtro, page, pageSize, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("{id:guid}")] public async Task<IActionResult> Detail(Guid id, CancellationToken ct) { try { return Ok(await tasks.GetAsync(TenantId, Guid.NewGuid(), id, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Detail)); } }
    [HttpPost("{id:guid}/assume")] public async Task<IActionResult> Assume(Guid id, [FromBody] AssumeMobileTaskRequest request, CancellationToken ct) { await tasks.SaveStatusAsync(TenantId, Guid.NewGuid(), id, "assumida", ct); return Ok(); }
    [HttpPost("{id:guid}/start")] public async Task<IActionResult> Start(Guid id, [FromBody] StartMobileTaskExecutionRequest request, CancellationToken ct) => Ok(await execution.StartAsync(TenantId, Guid.NewGuid(), id, request, ct));
    [HttpPut("{id:guid}/form")] public IActionResult Form(Guid id, [FromBody] SaveMobileTaskFormRequest request) => Ok();
    [HttpPut("{id:guid}/checklist")] public IActionResult Checklist(Guid id, [FromBody] SaveMobileTaskChecklistRequest request) => Ok();
    [HttpPost("{id:guid}/comments")] public IActionResult Comment(Guid id, [FromBody] AddMobileTaskCommentRequest request) => Ok();
    [HttpPost("{id:guid}/evidences")] public async Task<IActionResult> Evidence(Guid id, [FromBody] UploadMobileEvidenceRequest request, CancellationToken ct) => Ok(await evidence.AddEvidenceAsync(TenantId, Guid.NewGuid(), id, request, ct));
    [HttpPost("{id:guid}/signature")] public async Task<IActionResult> Signature(Guid id, [FromBody] CaptureMobileSignatureRequest request, CancellationToken ct) => Ok(new { id = await evidence.AddSignatureAsync(TenantId, Guid.NewGuid(), id, request, ct) });
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, [FromBody] CompleteMobileTaskRequest request, CancellationToken ct) => Ok(await execution.CompleteAsync(TenantId, Guid.NewGuid(), id, request, ct));
    [HttpPost("{id:guid}/approve")] public async Task<IActionResult> Approve(Guid id, [FromBody] ApproveMobileTaskRequest request, CancellationToken ct) => Ok(await approvals.DecideAsync(TenantId, Guid.NewGuid(), id, true, request.Comentario, ct));
    [HttpPost("{id:guid}/reject")] public async Task<IActionResult> Reject(Guid id, [FromBody] RejectMobileTaskRequest request, CancellationToken ct) => Ok(await approvals.DecideAsync(TenantId, Guid.NewGuid(), id, false, request.Comentario, ct));
}

[ApiController, Route("api/mobile/notifications")]
public sealed class MobileNotificationsController(IMobileNotificationRepository notifications) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpGet] public Task<IReadOnlyList<MobileNotificationResponse>> List(CancellationToken ct) => notifications.ListAsync(TenantId, Guid.NewGuid(), ct); [HttpPost("{id:guid}/read")] public async Task<IActionResult> Read(Guid id, CancellationToken ct) { await notifications.MarkReadAsync(TenantId, Guid.NewGuid(), id, ct); return Ok(); } }

[ApiController, Route("api/mobile/sync")]
public sealed class MobileSyncController(IMobileSyncRepository sync) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpPost("queue")] public async Task<IActionResult> Queue([FromBody] MobileSyncQueueRequest request, CancellationToken ct) { await sync.QueueAsync(TenantId, Guid.NewGuid(), request, ct); return Ok(); } [HttpPost("process")] public IActionResult Process() => Ok(); [HttpGet("status")] public Task<MobileSyncStatusResponse> Status(CancellationToken ct) => sync.GetStatusAsync(TenantId, Guid.NewGuid(), ct); }
