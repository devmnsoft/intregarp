namespace IntegraRP.Application.Auth;
public interface IPasswordService { bool Verify(Guid userId, string email, string? hash, string password); string Hash(Guid userId, string email, string password); bool IsValidNewPassword(string password, string confirmation, out string error); }
