using IntegraRP.Contracts.Onboarding;

namespace IntegraRP.Application.Onboarding;

public interface IUserPreferenceRepository
{
    Task<OnboardingStateDto> GetOnboardingAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken);
    Task<OnboardingStateDto> UpdateOnboardingStepAsync(Guid tenantId, Guid userId, UpdateOnboardingStepRequest request, CancellationToken cancellationToken);
    Task<OnboardingStateDto> DismissOnboardingAsync(Guid tenantId, Guid userId, DismissOnboardingRequest request, CancellationToken cancellationToken);
    Task<OnboardingStateDto> ReopenOnboardingAsync(Guid tenantId, Guid userId, ReopenOnboardingRequest request, CancellationToken cancellationToken);
    Task<OnboardingStateDto> ReconcileAsync(Guid tenantId, Guid userId, IReadOnlyCollection<int> completedSteps, long rowVersion, CancellationToken cancellationToken);
}

public interface IOnboardingProgressQuery
{
    Task<OnboardingFactsDto> GetFactsAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken);
}

public sealed class GetOnboardingStateUseCase(IUserPreferenceRepository repository)
{
    public Task<OnboardingStateDto> ExecuteAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken) =>
        repository.GetOnboardingAsync(tenantId, userId, cancellationToken);
}

public sealed class UpdateOnboardingStepUseCase(IUserPreferenceRepository repository)
{
    public Task<OnboardingStateDto> ExecuteAsync(Guid tenantId, Guid userId, UpdateOnboardingStepRequest request, CancellationToken cancellationToken)
    {
        global::IntegraRP.Domain.Onboarding.OnboardingProgress.RequireValidStep(request.Step);
        if (request.Completed) throw new ArgumentException("Etapas baseadas em dados são concluídas automaticamente.", nameof(request));
        return repository.UpdateOnboardingStepAsync(tenantId, userId, request, cancellationToken);
    }
}

public sealed class DismissOnboardingUseCase(IUserPreferenceRepository repository)
{
    public Task<OnboardingStateDto> ExecuteAsync(Guid tenantId, Guid userId, DismissOnboardingRequest request, CancellationToken cancellationToken) =>
        repository.DismissOnboardingAsync(tenantId, userId, request, cancellationToken);
}

public sealed class ReconcileOnboardingProgressUseCase(IOnboardingProgressQuery query, IUserPreferenceRepository repository)
{
    public async Task<OnboardingStateDto> ExecuteAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken)
    {
        var facts = await query.GetFactsAsync(tenantId, userId, cancellationToken);
        var state = await repository.GetOnboardingAsync(tenantId, userId, cancellationToken);
        var completed = new[] { facts.OrganizationConfirmed, facts.SectorsReviewed, facts.FirstCustomer, facts.FirstCategory,
            facts.FirstProduct, facts.FirstInventory, facts.FirstOrder, facts.FirstTask };
        return await repository.ReconcileAsync(tenantId, userId,
            completed.Select((value, index) => (value, step: index + 1)).Where(x => x.value).Select(x => x.step).ToArray(),
            state.RowVersion, cancellationToken);
    }
}
