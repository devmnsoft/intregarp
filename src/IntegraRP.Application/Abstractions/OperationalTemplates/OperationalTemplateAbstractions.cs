using IntegraRP.Contracts.OperationalTemplates;

namespace IntegraRP.Application.Abstractions.OperationalTemplates;

public interface IOperationalTemplateRepository { Task<IReadOnlyList<OperationalTemplateResponse>> ListAsync(Guid tenantId, CancellationToken cancellationToken); Task<OperationalTemplateResponse?> GetAsync(Guid tenantId, Guid id, CancellationToken cancellationToken); }
public interface IOperationalTemplatePackageRepository { Task<IReadOnlyList<OperationalTemplatePackageResponse>> ListAsync(Guid tenantId, CancellationToken cancellationToken); Task<OperationalTemplatePackageResponse?> GetAsync(Guid tenantId, Guid id, CancellationToken cancellationToken); }
public interface IOperationalTemplateInstallationRepository { Task<IReadOnlyList<OperationalTemplateInstallationResponse>> ListAsync(Guid tenantId, CancellationToken cancellationToken); Task<IReadOnlyList<OperationalTemplateInstallationLogResponse>> GetLogsAsync(Guid tenantId, Guid installationId, CancellationToken cancellationToken); }
public interface IOperationalTemplateInstaller { Task<InstallOperationalTemplateResponse> InstallTemplateAsync(Guid tenantId, Guid templateId, Guid? userId, IReadOnlyDictionary<string, string>? configuration, CancellationToken cancellationToken); Task<InstallOperationalTemplateResponse> InstallPackageAsync(Guid tenantId, Guid packageId, Guid? userId, IReadOnlyDictionary<string, string>? configuration, CancellationToken cancellationToken); }
public interface IOperationalTemplatePreviewService { Task<OperationalTemplatePreviewResponse> PreviewAsync(Guid tenantId, Guid templateId, CancellationToken cancellationToken); }
public interface IOperationalTemplateValidationService { Task<IReadOnlyList<string>> ValidateAsync(Guid tenantId, Guid templateId, CancellationToken cancellationToken); }
public interface IOperationalTemplateSeedService { Task SeedAsync(CancellationToken cancellationToken); }
