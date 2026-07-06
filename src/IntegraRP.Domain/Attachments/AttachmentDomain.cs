namespace IntegraRP.Domain.Attachments;

public sealed record AttachmentFile(Guid Id, Guid TenantId, string FileName, string ContentType, long SizeBytes, string Extension, string Sha256, string StorageKey);
public sealed record AttachmentLink(Guid Id, Guid TenantId, Guid AttachmentFileId, string EntityType, Guid EntityId);
public sealed record AttachmentVersion(Guid Id, Guid TenantId, Guid AttachmentFileId, int VersionNumber, string StorageKey, string Sha256);
public sealed record AttachmentAudit(Guid Id, Guid TenantId, Guid AttachmentFileId, Guid? UserId, string Action, DateTimeOffset CreatedAt);
public sealed record AttachmentThumbnail(Guid Id, Guid TenantId, Guid AttachmentFileId, string StorageKey, int Width, int Height);
public sealed record AttachmentSignature(Guid Id, Guid TenantId, Guid AttachmentFileId, string SignerName, DateTimeOffset SignedAt);
public sealed record AttachmentConfiguration(Guid Id, Guid TenantId, string AllowedExtensions, long MaxSizeBytes);
