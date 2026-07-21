namespace IntegraRP.Application.Auth;
public interface ITokenService { string CreateAccessToken(AuthUserRecord user, IReadOnlyList<string> roles, IReadOnlyList<string> permissions, Guid sessionId, DateTimeOffset expiresAt); DateTimeOffset GetAccessTokenExpiresAt(); }
