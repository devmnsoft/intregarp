using System.Text.Json;
using IntegraRP.Application.Abstractions.Mobile;
using IntegraRP.Application.Runtime;
using IntegraRP.Contracts.Mobile;
using IntegraRP.Api.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers.Mobile;

[ApiController]
[Route("api/mobile/auth")]
public sealed class MobileAuthController(IMobileDeviceRepository devices, ICurrentUserContext currentUser, ILogger<MobileAuthController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{
    [AllowAnonymous]
    [HttpPost("login")]
    public IActionResult Login([FromBody] MobileLoginRequest request) => Problem(title: "Contrato mobile legado", detail: "Use POST /api/auth/login com tenantSlug, email, password, deviceId e deviceName para autenticação JWT persistida.", statusCode: StatusCodes.Status308PermanentRedirect);
    [HttpPost("refresh")] public IActionResult Refresh() => Problem(title: "Contrato mobile legado", detail: "Use POST /api/auth/refresh para rotação persistida de refresh token.", statusCode: StatusCodes.Status308PermanentRedirect);
    [HttpPost("logout")] public IActionResult Logout() => NoContent();
    [HttpGet("me")] public IActionResult Me() => Ok(new MobileCurrentUserResponse(TenantId, currentUser.UserId, currentUser.Email ?? "Usuário autenticado", currentUser.Email ?? string.Empty, currentUser.Permissions.ToArray()));
    [HttpPost("/api/mobile/devices/register")] public async Task<IActionResult> Register([FromBody] RegisterMobileDeviceRequest request, CancellationToken ct) { try { return Ok(new { id = await devices.RegisterAsync(TenantId, currentUser.UserId, request, ct) }); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Register)); } }
}

[ApiController, Route("api/mobile/dashboard")]
public sealed class MobileDashboardController(IMobileDashboardService dashboard, ICurrentUserContext currentUser, ILogger<MobileDashboardController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpGet] public async Task<IActionResult> Get(CancellationToken ct) { try { return Ok(await dashboard.GetAsync(TenantId, currentUser.UserId, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } } }

[ApiController, Route("api/mobile/tasks")]
public sealed class MobileTasksController(IMobileTaskRepository tasks, IMobileTaskExecutionService execution, IMobileEvidenceRepository evidence, IMobileApprovalService approvals, OperationalRuntimeUseCases useCases, ICurrentUserContext currentUser, ILogger<MobileTasksController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List([FromQuery] string? filtro, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken ct = default) { try { return Ok(await tasks.ListMyTasksAsync(TenantId, currentUser.UserId, filtro, page, pageSize, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("{id:guid}")] public async Task<IActionResult> Detail(Guid id, CancellationToken ct) { try { return Ok(await tasks.GetAsync(TenantId, currentUser.UserId, id, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Detail)); } }
    [HttpPost("{id:guid}/assume")] public async Task<IActionResult> Assume(Guid id, [FromBody] AssumeMobileTaskRequest request, CancellationToken ct) { await tasks.SaveStatusAsync(TenantId, currentUser.UserId, id, "assumida", ct); return Ok(); }
    [HttpPost("{id:guid}/start")] public async Task<IActionResult> Start(Guid id, [FromBody] StartMobileTaskExecutionRequest request, CancellationToken ct) => Ok(await execution.StartAsync(TenantId, currentUser.UserId, id, request, ct));
    [HttpPut("{id:guid}/form")] public async Task<IActionResult> Form(Guid id, [FromBody] SaveMobileTaskFormRequest request, CancellationToken ct) => ToAction(await useCases.SaveTaskFormAsync(TenantId, id, new SaveTaskJsonRequest(JsonSerializer.Serialize(request.Respostas)), ct));
    [HttpPut("{id:guid}/checklist")] public async Task<IActionResult> Checklist(Guid id, [FromBody] SaveMobileTaskChecklistRequest request, CancellationToken ct) => ToAction(await useCases.SaveTaskChecklistAsync(TenantId, id, new SaveTaskJsonRequest(JsonSerializer.Serialize(request.Itens)), ct));
    [HttpPost("{id:guid}/comments")] public async Task<IActionResult> Comment(Guid id, [FromBody] AddMobileTaskCommentRequest request, CancellationToken ct) => ToAction(await useCases.CommentTaskAsync(currentUser, id, new AddTaskCommentRequest(request.Comentario), ct));
    [HttpPost("{id:guid}/evidences")] public async Task<IActionResult> Evidence(Guid id, [FromBody] UploadMobileEvidenceRequest request, CancellationToken ct) => Ok(await evidence.AddEvidenceAsync(TenantId, currentUser.UserId, id, request, ct));
    [HttpPost("{id:guid}/signature")] public async Task<IActionResult> Signature(Guid id, [FromBody] CaptureMobileSignatureRequest request, CancellationToken ct) => Ok(new { id = await evidence.AddSignatureAsync(TenantId, currentUser.UserId, id, request, ct) });
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, [FromBody] CompleteMobileTaskRequest request, CancellationToken ct) => Ok(await execution.CompleteAsync(TenantId, currentUser.UserId, id, request, ct));
    private IActionResult ToAction<T>(IntegraRP.Application.Common.Result<T> result) => result.IsSuccess ? Ok(result.Value) : Problem(title: "Falha de validação", detail: result.Error, statusCode: 400);
    [HttpPost("{id:guid}/approve")] public async Task<IActionResult> Approve(Guid id, [FromBody] ApproveMobileTaskRequest request, CancellationToken ct) => Ok(await approvals.DecideAsync(TenantId, currentUser.UserId, id, true, request.Comentario, ct));
    [HttpPost("{id:guid}/reject")] public async Task<IActionResult> Reject(Guid id, [FromBody] RejectMobileTaskRequest request, CancellationToken ct) => Ok(await approvals.DecideAsync(TenantId, currentUser.UserId, id, false, request.Comentario, ct));
}

[ApiController, Route("api/mobile/notifications")]
public sealed class MobileNotificationsController(IMobileNotificationRepository notifications, ICurrentUserContext currentUser) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpGet] public Task<IReadOnlyList<MobileNotificationResponse>> List(CancellationToken ct) => notifications.ListAsync(TenantId, currentUser.UserId, ct); [HttpPost("{id:guid}/read")] public async Task<IActionResult> Read(Guid id, CancellationToken ct) { await notifications.MarkReadAsync(TenantId, currentUser.UserId, id, ct); return Ok(); } }

[ApiController, Route("api/mobile/sync")]
public sealed class MobileSyncController(IMobileSyncRepository sync, ICurrentUserContext currentUser) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpPost("queue")] public async Task<IActionResult> Queue([FromBody] MobileSyncQueueRequest request, CancellationToken ct) { await sync.QueueAsync(TenantId, currentUser.UserId, request, ct); return Accepted(new { status = "queued" }); } [HttpPost("process")] public IActionResult Process() => Accepted(new { status = "processing", mode = "idempotent-worker-compatible" }); [HttpGet("status")] public Task<MobileSyncStatusResponse> Status(CancellationToken ct) => sync.GetStatusAsync(TenantId, currentUser.UserId, ct); }
