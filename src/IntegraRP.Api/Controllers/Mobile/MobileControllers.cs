using IntegraRP.Application.Abstractions.Mobile;
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
    public IActionResult Login([FromBody] MobileLoginRequest request) => Problem(title: "Autenticação mobile não configurada", detail: "Use o endpoint de autenticação JWT corporativo antes de acessar o runtime mobile.", statusCode: StatusCodes.Status501NotImplemented);
    [HttpPost("refresh")] public IActionResult Refresh() => Problem(title: "Refresh token mobile não configurado", detail: "A rotação de refresh token deve ser feita pelo provedor JWT corporativo.", statusCode: StatusCodes.Status501NotImplemented);
    [HttpPost("logout")] public IActionResult Logout() => NoContent();
    [HttpGet("me")] public IActionResult Me() => Ok(new MobileCurrentUserResponse(TenantId, currentUser.UserId, currentUser.Email ?? "Usuário autenticado", currentUser.Email ?? string.Empty, currentUser.Permissions.ToArray()));
    [HttpPost("/api/mobile/devices/register")] public async Task<IActionResult> Register([FromBody] RegisterMobileDeviceRequest request, CancellationToken ct) { try { return Ok(new { id = await devices.RegisterAsync(TenantId, currentUser.UserId, request, ct) }); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Register)); } }
}

[ApiController, Route("api/mobile/dashboard")]
public sealed class MobileDashboardController(IMobileDashboardService dashboard, ICurrentUserContext currentUser, ILogger<MobileDashboardController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpGet] public async Task<IActionResult> Get(CancellationToken ct) { try { return Ok(await dashboard.GetAsync(TenantId, currentUser.UserId, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Get)); } } }

[ApiController, Route("api/mobile/tasks")]
public sealed class MobileTasksController(IMobileTaskRepository tasks, IMobileTaskExecutionService execution, IMobileEvidenceRepository evidence, IMobileApprovalService approvals, ICurrentUserContext currentUser, ILogger<MobileTasksController> logger) : IntegraRP.Api.Controllers.IntegraControllerBase
{
    [HttpGet] public async Task<IActionResult> List([FromQuery] string? filtro, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken ct = default) { try { return Ok(await tasks.ListMyTasksAsync(TenantId, currentUser.UserId, filtro, page, pageSize, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(List)); } }
    [HttpGet("{id:guid}")] public async Task<IActionResult> Detail(Guid id, CancellationToken ct) { try { return Ok(await tasks.GetAsync(TenantId, currentUser.UserId, id, ct)); } catch (Exception ex) { return ProblemFrom(ex, logger, nameof(Detail)); } }
    [HttpPost("{id:guid}/assume")] public async Task<IActionResult> Assume(Guid id, [FromBody] AssumeMobileTaskRequest request, CancellationToken ct) { await tasks.SaveStatusAsync(TenantId, currentUser.UserId, id, "assumida", ct); return Ok(); }
    [HttpPost("{id:guid}/start")] public async Task<IActionResult> Start(Guid id, [FromBody] StartMobileTaskExecutionRequest request, CancellationToken ct) => Ok(await execution.StartAsync(TenantId, currentUser.UserId, id, request, ct));
    [HttpPut("{id:guid}/form")] public IActionResult Form(Guid id, [FromBody] SaveMobileTaskFormRequest request) => Problem(title: "Persistência de formulário mobile indisponível", detail: "Endpoint temporariamente bloqueado para não simular sucesso sem persistência.", statusCode: StatusCodes.Status501NotImplemented);
    [HttpPut("{id:guid}/checklist")] public IActionResult Checklist(Guid id, [FromBody] SaveMobileTaskChecklistRequest request) => Problem(title: "Persistência de checklist mobile indisponível", detail: "Endpoint temporariamente bloqueado para não simular sucesso sem persistência.", statusCode: StatusCodes.Status501NotImplemented);
    [HttpPost("{id:guid}/comments")] public IActionResult Comment(Guid id, [FromBody] AddMobileTaskCommentRequest request) => Problem(title: "Comentários mobile indisponíveis", detail: "Endpoint temporariamente bloqueado para não simular sucesso sem persistência.", statusCode: StatusCodes.Status501NotImplemented);
    [HttpPost("{id:guid}/evidences")] public async Task<IActionResult> Evidence(Guid id, [FromBody] UploadMobileEvidenceRequest request, CancellationToken ct) => Ok(await evidence.AddEvidenceAsync(TenantId, currentUser.UserId, id, request, ct));
    [HttpPost("{id:guid}/signature")] public async Task<IActionResult> Signature(Guid id, [FromBody] CaptureMobileSignatureRequest request, CancellationToken ct) => Ok(new { id = await evidence.AddSignatureAsync(TenantId, currentUser.UserId, id, request, ct) });
    [HttpPost("{id:guid}/complete")] public async Task<IActionResult> Complete(Guid id, [FromBody] CompleteMobileTaskRequest request, CancellationToken ct) => Ok(await execution.CompleteAsync(TenantId, currentUser.UserId, id, request, ct));
    [HttpPost("{id:guid}/approve")] public async Task<IActionResult> Approve(Guid id, [FromBody] ApproveMobileTaskRequest request, CancellationToken ct) => Ok(await approvals.DecideAsync(TenantId, currentUser.UserId, id, true, request.Comentario, ct));
    [HttpPost("{id:guid}/reject")] public async Task<IActionResult> Reject(Guid id, [FromBody] RejectMobileTaskRequest request, CancellationToken ct) => Ok(await approvals.DecideAsync(TenantId, currentUser.UserId, id, false, request.Comentario, ct));
}

[ApiController, Route("api/mobile/notifications")]
public sealed class MobileNotificationsController(IMobileNotificationRepository notifications, ICurrentUserContext currentUser) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpGet] public Task<IReadOnlyList<MobileNotificationResponse>> List(CancellationToken ct) => notifications.ListAsync(TenantId, currentUser.UserId, ct); [HttpPost("{id:guid}/read")] public async Task<IActionResult> Read(Guid id, CancellationToken ct) { await notifications.MarkReadAsync(TenantId, currentUser.UserId, id, ct); return Ok(); } }

[ApiController, Route("api/mobile/sync")]
public sealed class MobileSyncController(IMobileSyncRepository sync, ICurrentUserContext currentUser) : IntegraRP.Api.Controllers.IntegraControllerBase
{ [HttpPost("queue")] public async Task<IActionResult> Queue([FromBody] MobileSyncQueueRequest request, CancellationToken ct) { await sync.QueueAsync(TenantId, currentUser.UserId, request, ct); return Accepted(new { status = "queued" }); } [HttpPost("process")] public IActionResult Process() => Problem(title: "Processamento mobile síncrono indisponível", detail: "O processamento deve ocorrer pelo Worker com lock, retry e idempotência.", statusCode: StatusCodes.Status501NotImplemented); [HttpGet("status")] public Task<MobileSyncStatusResponse> Status(CancellationToken ct) => sync.GetStatusAsync(TenantId, currentUser.UserId, ct); }
