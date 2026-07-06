using System.Text.RegularExpressions;
using IntegraRP.Application.Abstractions.Services;

namespace IntegraRP.Infrastructure.Services;

public sealed class DataMaskingService : IDataMaskingService
{
    public string MaskCpf(string value, bool canSeeSensitive = false)
    {
        if (canSeeSensitive || string.IsNullOrWhiteSpace(value))
        {
            return value;
        }

        var digits = OnlyDigits(value);
        return digits.Length == 11 ? $"***.***.***-{digits[^2..]}" : "***";
    }

    public string MaskCnpj(string value, bool canSeeSensitive = false)
    {
        if (canSeeSensitive || string.IsNullOrWhiteSpace(value))
        {
            return value;
        }

        var digits = OnlyDigits(value);
        return digits.Length == 14 ? $"**.***.***/****-{digits[^2..]}" : "***";
    }

    public string MaskEmail(string value, bool canSeeSensitive = false)
    {
        if (canSeeSensitive || string.IsNullOrWhiteSpace(value))
        {
            return value;
        }

        var parts = value.Split('@', 2);
        if (parts.Length != 2 || parts[0].Length == 0)
        {
            return "***";
        }

        return $"{parts[0][0]}***@{parts[1]}";
    }

    public string MaskPhone(string value, bool canSeeSensitive = false)
    {
        if (canSeeSensitive || string.IsNullOrWhiteSpace(value))
        {
            return value;
        }

        var digits = OnlyDigits(value);
        return digits.Length >= 4 ? $"(**) *****-{digits[^4..]}" : "***";
    }

    public string MaskFinancial(string value, bool canSeeSensitive = false)
    {
        return canSeeSensitive ? value : "R$ ***";
    }

    public string MaskDynamicField(string value, bool sensitiveLgpd, bool canSeeSensitive = false)
    {
        return sensitiveLgpd && !canSeeSensitive ? "***" : value;
    }

    private static string OnlyDigits(string value)
    {
        return Regex.Replace(value, "\\D", string.Empty, RegexOptions.None, TimeSpan.FromMilliseconds(100));
    }
}

public sealed class InMemoryLgpdAuditService : ILgpdAuditService
{
    private readonly List<LgpdAccessLog> logs = [];
    private readonly object gate = new();

    public Task RegisterSensitiveAccessAsync(LgpdAccessLog log, CancellationToken cancellationToken)
    {
        lock (gate)
        {
            logs.Add(log);
        }

        return Task.CompletedTask;
    }

    public IReadOnlyList<LgpdAccessLog> GetRecentAccesses(Guid tenantId)
    {
        lock (gate)
        {
            return logs
                .Where(log => log.TenantId == tenantId)
                .OrderByDescending(log => log.AccessedAt)
                .Take(100)
                .ToArray();
        }
    }
}
