using IntegraRP.Contracts.Onboarding;

namespace IntegraRP.Application.Onboarding;

public interface IUserPreferenceRepository
{
    Task<OnboardingStateDto> GetOnboardingAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken);
    Task<OnboardingStateDto> UpdateOnboardingStepAsync(Guid tenantId, Guid userId, UpdateOnboardingStepRequest request, CancellationToken cancellationToken);
    Task<OnboardingStateDto> DismissOnboardingAsync(Guid tenantId, Guid userId, DismissOnboardingRequest request, CancellationToken cancellationToken);
}

public sealed class GetOnboardingStateUseCase(IUserPreferenceRepository repository)
{
    public Task<OnboardingStateDto> ExecuteAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken) =>
        repository.GetOnboardingAsync(tenantId, userId, cancellationToken);
}

public sealed class UpdateOnboardingStepUseCase(IUserPreferenceRepository repository)
{
    public Task<OnboardingStateDto> ExecuteAsync(Guid tenantId, Guid userId, UpdateOnboardingStepRequest request, CancellationToken cancellationToken) =>
        repository.UpdateOnboardingStepAsync(tenantId, userId, request, cancellationToken);
}

public sealed class DismissOnboardingUseCase(IUserPreferenceRepository repository)
{
    public Task<OnboardingStateDto> ExecuteAsync(Guid tenantId, Guid userId, DismissOnboardingRequest request, CancellationToken cancellationToken) =>
        repository.DismissOnboardingAsync(tenantId, userId, request, cancellationToken);
}
