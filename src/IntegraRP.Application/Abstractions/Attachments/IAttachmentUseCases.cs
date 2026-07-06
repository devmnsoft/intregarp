using IntegraRP.Application.Common;

namespace IntegraRP.Application.Abstractions.Attachments;

public sealed record AttachmentCommand(Guid TenantId, Guid UserId, string PayloadJson);
public sealed record AttachmentResult(Guid Id, string StorageKey, string PayloadJson);
public interface IAttachmentUseCases
{
    Task<Result<AttachmentResult>> UploadAsync(AttachmentCommand command, Stream content, CancellationToken cancellationToken);
    Task<Result<AttachmentResult>> LinkAsync(Guid attachmentId, AttachmentCommand command, CancellationToken cancellationToken);
    Task<Result<Stream>> DownloadAsync(Guid attachmentId, AttachmentCommand command, CancellationToken cancellationToken);
    Task<Result<IReadOnlyList<AttachmentResult>>> ListForEntityAsync(Guid tenantId, string entityType, Guid entityId, CancellationToken cancellationToken);
    Task<Result<AttachmentResult>> DeleteAsync(Guid attachmentId, AttachmentCommand command, CancellationToken cancellationToken);
    Task<Result<bool>> ValidateAccessAsync(Guid attachmentId, AttachmentCommand command, CancellationToken cancellationToken);
}
