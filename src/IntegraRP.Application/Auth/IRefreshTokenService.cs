namespace IntegraRP.Application.Auth;
public interface IRefreshTokenService { string CreateToken(); string HashToken(string token); DateTimeOffset GetRefreshTokenExpiresAt(); }
