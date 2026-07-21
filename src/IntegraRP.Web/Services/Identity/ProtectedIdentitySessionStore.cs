using System.Collections.Concurrent;
using System.Text.Json;
using Microsoft.AspNetCore.DataProtection;

namespace IntegraRP.Web.Services.Identity;

public sealed class ProtectedIdentitySessionStore(IDataProtectionProvider protectionProvider, TimeProvider timeProvider) : IIdentitySessionStore
{
    private static readonly ConcurrentDictionary<string, string> Sessions = new();
    private readonly IDataProtector _protector = protectionProvider.CreateProtector("IntegraRP.Web.IdentitySession.v1");

    public Task StoreAsync(string sessionId, IdentitySessionTokens tokens, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        Sessions[sessionId] = _protector.Protect(JsonSerializer.Serialize(tokens));
        return Task.CompletedTask;
    }

    public Task<IdentitySessionTokens?> GetAsync(string sessionId, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        if (!Sessions.TryGetValue(sessionId, out var protectedPayload)) return Task.FromResult<IdentitySessionTokens?>(null);
        try
        {
            var tokens = JsonSerializer.Deserialize<IdentitySessionTokens>(_protector.Unprotect(protectedPayload));
            if (tokens is null || tokens.ExpiresAt <= timeProvider.GetUtcNow().AddMinutes(-10))
            {
                Sessions.TryRemove(sessionId, out _);
                return Task.FromResult<IdentitySessionTokens?>(null);
            }
            return Task.FromResult<IdentitySessionTokens?>(tokens);
        }
        catch
        {
            Sessions.TryRemove(sessionId, out _);
            return Task.FromResult<IdentitySessionTokens?>(null);
        }
    }

    public Task RemoveAsync(string sessionId, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        Sessions.TryRemove(sessionId, out _);
        return Task.CompletedTask;
    }
}
