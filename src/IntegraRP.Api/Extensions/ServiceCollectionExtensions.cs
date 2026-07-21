using System.Text;
using IntegraRP.Api.Security;
using System.Security.Claims;
using IntegraRP.Application.Auth;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

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
                var secret = configuration["Jwt:Secret"] ?? Environment.GetEnvironmentVariable("INTEGRARP_JWT_SECRET");
                if (string.IsNullOrWhiteSpace(secret) || secret.Length < 32)
                {
                    throw new InvalidOperationException("Jwt:Secret/INTEGRARP_JWT_SECRET deve ser configurado fora do repositório com no mínimo 32 caracteres.");
                }
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
                options.Events = new JwtBearerEvents
                {
                    OnTokenValidated = async context =>
                    {
                        var userIdText = context.Principal?.FindFirstValue(ClaimTypes.NameIdentifier) ?? context.Principal?.FindFirstValue("sub");
                        var tenantIdText = context.Principal?.FindFirstValue("tenant_id");
                        var sessionIdText = context.Principal?.FindFirstValue("session_id");
                        if (!Guid.TryParse(userIdText, out var userId) || !Guid.TryParse(tenantIdText, out var tenantId) || !Guid.TryParse(sessionIdText, out var sessionId))
                        {
                            context.Fail("Token sem sessão válida.");
                            return;
                        }

                        var repository = context.HttpContext.RequestServices.GetRequiredService<IAuthenticationRepository>();
                        if (!await repository.IsSessionActiveAsync(tenantId, userId, sessionId, context.HttpContext.RequestAborted))
                        {
                            context.Fail("Sessão revogada ou expirada.");
                        }
                    }
                };
            });
        services.AddAuthorization(options =>
        {
            options.FallbackPolicy = new AuthorizationPolicyBuilder()
                .RequireAuthenticatedUser()
                .Build();
            foreach (var permission in ApiPermissions.All)
            {
                options.AddPolicy(permission, policy => policy.RequireAuthenticatedUser().RequireClaim(ApiPermissions.ClaimType, permission));
            }
        });
        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen(options =>
        {
            options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                Description = "JWT Authorization header usando o esquema Bearer.",
                Name = "Authorization",
                In = ParameterLocation.Header,
                Type = SecuritySchemeType.Http,
                Scheme = "bearer",
                BearerFormat = "JWT"
            });
            options.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                [new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
                }] = Array.Empty<string>()
            });
        });
        services.AddHealthChecks();
        services.AddCors();
        services.AddProblemDetails();
        services.Configure<ApiBehaviorOptions>(options => options.SuppressModelStateInvalidFilter = false);
        return services;
    }
}
