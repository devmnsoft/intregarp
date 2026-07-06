namespace IntegraRP.Application.Abstractions.Services;

public sealed record LgpdAccessLog(
    Guid TenantId,
    Guid? UserId,
    string Resource,
    string Field,
    string Reason,
    string CorrelationId,
    DateTimeOffset AccessedAt);

public interface IDataMaskingService
{
    string MaskCpf(string value, bool canSeeSensitive = false);

    string MaskCnpj(string value, bool canSeeSensitive = false);

    string MaskEmail(string value, bool canSeeSensitive = false);

    string MaskPhone(string value, bool canSeeSensitive = false);

    string MaskFinancial(string value, bool canSeeSensitive = false);

    string MaskDynamicField(string value, bool sensitiveLgpd, bool canSeeSensitive = false);
}

public interface ILgpdAuditService
{
    Task RegisterSensitiveAccessAsync(LgpdAccessLog log, CancellationToken cancellationToken);

    IReadOnlyList<LgpdAccessLog> GetRecentAccesses(Guid tenantId);
}
