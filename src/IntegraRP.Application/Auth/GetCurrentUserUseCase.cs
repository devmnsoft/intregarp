using IntegraRP.Contracts.Auth;
namespace IntegraRP.Application.Auth;
public sealed class GetCurrentUserUseCase(IAuthenticationRepository repository) { public async Task<AuthResult<CurrentUserResponse>> ExecuteAsync(Guid tenantId, Guid userId, Guid sessionId, string? email, CancellationToken ct) { var roles = await repository.GetRolesAsync(tenantId, userId, ct); var permissions = await repository.GetPermissionsAsync(tenantId, userId, ct); return AuthResult<CurrentUserResponse>.Ok(new(userId, tenantId, email, sessionId, roles, permissions)); } }
