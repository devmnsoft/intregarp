namespace IntegraRP.Application.Auth;
public interface IPasswordResetSender { Task SendAsync(string email, string token, CancellationToken ct); }
