using System.Text;
using IntegraRP.Api.Security;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace IntegraRP.Api.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddApiServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddHttpContextAccessor();
        services.AddScoped<ICurrentUserContext, CurrentUserContext>();
        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                var issuer = configuration["Jwt:Issuer"] ?? "IntegraRP";
                var audience = configuration["Jwt:Audience"] ?? "IntegraRP.Api";
                var secret = configuration["Jwt:Secret"] ?? "dev-only-change-me-in-production-32chars";
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = issuer,
                    ValidAudience = audience,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret)),
                    ClockSkew = TimeSpan.FromMinutes(2)
                };
            });
        services.AddAuthorization(options =>
        {
            foreach (var permission in ApiPermissions.All)
            {
                options.AddPolicy(permission, policy => policy.RequireAuthenticatedUser().RequireClaim(ApiPermissions.ClaimType, permission));
            }
        });
        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();
        services.AddHealthChecks();
        services.AddCors();
        services.AddProblemDetails();
        services.Configure<ApiBehaviorOptions>(options => options.SuppressModelStateInvalidFilter = false);
        return services;
    }
}
