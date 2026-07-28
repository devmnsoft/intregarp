namespace IntegraRP.Contracts.Onboarding;

public sealed record OnboardingStateDto(
    int CurrentStep,
    IReadOnlyCollection<int> CompletedSteps,
    bool Dismissed,
    bool Completed,
    int Percentage,
    DateTimeOffset LastInteractionAt,
    long RowVersion);

public sealed record UpdateOnboardingStepRequest(int Step, bool Completed, long RowVersion);
public sealed record DismissOnboardingRequest(long RowVersion);
