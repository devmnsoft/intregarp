namespace IntegraRP.Application.Auth;

public sealed record AuthHttpContext(string? Ip, string? UserAgent, string CorrelationId);
