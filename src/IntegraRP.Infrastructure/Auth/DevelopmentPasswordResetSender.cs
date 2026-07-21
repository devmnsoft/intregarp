using IntegraRP.Application.Auth;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Auth;
public sealed class DevelopmentPasswordResetSender(IHostEnvironment env, IConfiguration config, ILogger<DevelopmentPasswordResetSender> logger) : IPasswordResetSender
{
    public Task SendAsync(string email, string token, CancellationToken ct) { if (env.IsDevelopment() && config.GetValue<bool>("Auth:ExposePasswordResetTokenInDevelopment")) logger.LogInformation("SANDBOX reset password token gerado para {Email}: {Token}", email, token); else logger.LogInformation("SANDBOX reset password solicitado para {Email}; token omitido.", email); return Task.CompletedTask; }
}
