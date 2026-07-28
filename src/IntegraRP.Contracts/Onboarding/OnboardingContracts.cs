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
public sealed record ReopenOnboardingRequest(long RowVersion);
public sealed record OnboardingFactsDto(
    bool OrganizationConfirmed, bool SectorsReviewed, bool FirstCustomer, bool FirstCategory,
    bool FirstProduct, bool FirstInventory, bool FirstOrder, bool FirstTask);

public enum OnboardingStepStatus { Pending, InProgress, Completed, Blocked, TemporarilyDismissed }
public sealed record OnboardingStepStatusDto(int Step, OnboardingStepStatus Status, string? BlockingReason);
