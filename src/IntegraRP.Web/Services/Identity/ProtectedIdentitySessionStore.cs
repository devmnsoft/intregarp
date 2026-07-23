using IntegraRP.Contracts.Auth;
using System.Text.Json;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.Extensions.Caching.Distributed;

namespace IntegraRP.Web.Services.Identity;

public sealed class ProtectedIdentitySessionStore(
    IDistributedCache cache,
    IDataProtectionProvider protectionProvider,
    TimeProvider timeProvider) : IIdentitySessionStore
{
    private const string Prefix = "integrarp:web:identity-session:";
    private readonly IDataProtector _protector = protectionProvider.CreateProtector("IntegraRP.Web.IdentitySession.v128");

    public async Task StoreAsync(string sessionId, IdentitySessionTokens tokens, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var payload = _protector.Protect(JsonSerializer.Serialize(tokens));
        var ttl = tokens.ExpiresAt - timeProvider.GetUtcNow();
        if (ttl <= TimeSpan.Zero) ttl = TimeSpan.FromMinutes(1);
        await cache.SetStringAsync(Key(sessionId), payload, new DistributedCacheEntryOptions
        {
            AbsoluteExpirationRelativeToNow = ttl.Add(TimeSpan.FromMinutes(5))
        }, cancellationToken);
    }

    public async Task<IdentitySessionTokens?> GetAsync(string sessionId, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var protectedPayload = await cache.GetStringAsync(Key(sessionId), cancellationToken);
        if (string.IsNullOrWhiteSpace(protectedPayload)) return null;
        try
        {
            var tokens = JsonSerializer.Deserialize<IdentitySessionTokens>(_protector.Unprotect(protectedPayload));
            if (tokens is null || tokens.ExpiresAt <= timeProvider.GetUtcNow())
            {
                await RemoveAsync(sessionId, cancellationToken);
                return null;
            }
            return tokens;
        }
        catch
        {
            await RemoveAsync(sessionId, cancellationToken);
            return null;
        }
    }

    public Task RemoveAsync(string sessionId, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return cache.RemoveAsync(Key(sessionId), cancellationToken);
    }

    private static string Key(string sessionId) => Prefix + sessionId;
}
