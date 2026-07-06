using IntegraRP.Application.Common;

namespace IntegraRP.Application.Abstractions.Reports;

public sealed record ReportCommand(Guid TenantId, Guid UserId, string PayloadJson);
public sealed record ReportResult(Guid Id, string Status, string PayloadJson);
public interface IReportUseCases
{
    Task<Result<ReportResult>> CreateDefinitionAsync(ReportCommand command, CancellationToken cancellationToken);
    Task<Result<ReportResult>> ExecuteAsync(Guid reportId, ReportCommand command, CancellationToken cancellationToken);
    Task<Result<ReportResult>> ExportAsync(Guid executionId, ReportCommand command, CancellationToken cancellationToken);
    Task<Result<IReadOnlyList<ReportResult>>> ListExecutionsAsync(Guid tenantId, Guid reportId, CancellationToken cancellationToken);
    Task<Result<ReportResult>> ScheduleAsync(Guid reportId, ReportCommand command, CancellationToken cancellationToken);
    Task<Result<Stream>> DownloadExportAsync(Guid exportId, ReportCommand command, CancellationToken cancellationToken);
}
