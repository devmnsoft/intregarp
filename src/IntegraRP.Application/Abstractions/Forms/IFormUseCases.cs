using IntegraRP.Application.Common;

namespace IntegraRP.Application.Abstractions.Forms;

public sealed record FormCommand(Guid TenantId, Guid UserId, string PayloadJson);
public sealed record FormResult(Guid Id, string PayloadJson);
public interface IFormBuilderUseCases
{
    Task<Result<FormResult>> CreateFormAsync(FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> AddSectionAsync(Guid formId, FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> AddFieldAsync(Guid sectionId, FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> UpdateFieldAsync(Guid fieldId, FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> ReorderFieldsAsync(Guid sectionId, FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> AddRuleAsync(Guid formId, FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> PublishVersionAsync(Guid formId, FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> PreviewAsync(Guid formId, Guid tenantId, CancellationToken cancellationToken);
    Task<Result<FormResult>> SubmitResponseAsync(Guid versionId, FormCommand command, CancellationToken cancellationToken);
    Task<Result<FormResult>> GetResponseAsync(Guid responseId, Guid tenantId, CancellationToken cancellationToken);
}
