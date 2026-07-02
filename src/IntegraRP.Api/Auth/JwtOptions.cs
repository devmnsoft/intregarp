namespace IntegraRP.Api.Auth;

public sealed class JwtOptions
{
    public string Issuer { get; set; } = "IntegraRP";
    public string Audience { get; set; } = "IntegraRP.Api";
}
