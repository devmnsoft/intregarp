using IntegraRP.Application.Abstractions.Attachments;
using IntegraRP.Application.Abstractions.Automation;
using IntegraRP.Application.Abstractions.Forms;
using IntegraRP.Application.Abstractions.Notifications;
using IntegraRP.Application.Abstractions.Reports;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[Authorize]
[ApiController]
public abstract class V11ControllerBase : ControllerBase
{
    protected static IActionResult ToActionResult<T>(ControllerBase controller, IntegraRP.Application.Common.Result<T> result) =>
        result.IsSuccess ? controller.Ok(result.Value) : controller.Problem(result.Error, statusCode: StatusCodes.Status400BadRequest);
}

[Route("api/forms")]
public sealed class FormsController(IFormBuilderUseCases useCases) : V11ControllerBase
{
    [HttpPost] public async Task<IActionResult> Create([FromBody] FormCommand command, CancellationToken ct) => ToActionResult(this, await useCases.CreateFormAsync(command, ct));
    [HttpGet("{id:guid}/preview")] public async Task<IActionResult> Preview(Guid id, [FromQuery] Guid tenantId, CancellationToken ct) => ToActionResult(this, await useCases.PreviewAsync(id, tenantId, ct));
    [HttpPost("versions/{versionId:guid}/responses")] public async Task<IActionResult> Submit(Guid versionId, [FromBody] FormCommand command, CancellationToken ct) => ToActionResult(this, await useCases.SubmitResponseAsync(versionId, command, ct));
}

[Route("api/automation")]
public sealed class AutomationController(IAutomationUseCases useCases) : V11ControllerBase
{
    [HttpPost("rules")] public async Task<IActionResult> CreateRule([FromBody] AutomationCommand command, CancellationToken ct) => ToActionResult(this, await useCases.CreateRuleAsync(command, ct));
    [HttpPost("rules/{id:guid}/execute")] public async Task<IActionResult> Execute(Guid id, [FromBody] AutomationCommand command, CancellationToken ct) => ToActionResult(this, await useCases.ExecuteAsync(id, command, ct));
    [HttpPost("executions/{id:guid}/retry")] public async Task<IActionResult> Retry(Guid id, [FromBody] AutomationCommand command, CancellationToken ct) => ToActionResult(this, await useCases.RetryAsync(id, command, ct));
}

[Route("api/attachments")]
public sealed class AttachmentsController(IAttachmentUseCases useCases) : V11ControllerBase
{
    [HttpPost] public async Task<IActionResult> Upload([FromBody] AttachmentCommand command, CancellationToken ct) => ToActionResult(this, await useCases.UploadAsync(command, Stream.Null, ct));
    [HttpPost("{id:guid}/links")] public async Task<IActionResult> Link(Guid id, [FromBody] AttachmentCommand command, CancellationToken ct) => ToActionResult(this, await useCases.LinkAsync(id, command, ct));
    [HttpDelete("{id:guid}")] public async Task<IActionResult> Delete(Guid id, [FromBody] AttachmentCommand command, CancellationToken ct) => ToActionResult(this, await useCases.DeleteAsync(id, command, ct));
}

[Route("api/notifications")]
public sealed class NotificationsController(INotificationUseCases useCases) : V11ControllerBase
{
    [HttpPost] public async Task<IActionResult> Create([FromBody] NotificationCommand command, CancellationToken ct) => ToActionResult(this, await useCases.CreateAsync(command, ct));
    [HttpPost("{id:guid}/read")] public async Task<IActionResult> Read(Guid id, [FromBody] NotificationCommand command, CancellationToken ct) => ToActionResult(this, await useCases.MarkAsReadAsync(id, command, ct));
}

[Route("api/reports")]
public sealed class ReportsController(IReportUseCases useCases) : V11ControllerBase
{
    [HttpPost] public async Task<IActionResult> Create([FromBody] ReportCommand command, CancellationToken ct) => ToActionResult(this, await useCases.CreateDefinitionAsync(command, ct));
    [HttpPost("{id:guid}/execute")] public async Task<IActionResult> Execute(Guid id, [FromBody] ReportCommand command, CancellationToken ct) => ToActionResult(this, await useCases.ExecuteAsync(id, command, ct));
    [HttpPost("executions/{id:guid}/export")] public async Task<IActionResult> Export(Guid id, [FromBody] ReportCommand command, CancellationToken ct) => ToActionResult(this, await useCases.ExportAsync(id, command, ct));
}
