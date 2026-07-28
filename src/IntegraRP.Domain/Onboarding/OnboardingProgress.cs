namespace IntegraRP.Domain.Onboarding;

public static class OnboardingProgress
{
    public const int TotalSteps = 8;

    public static int RequireValidStep(int step) => step is >= 1 and <= TotalSteps
        ? step
        : throw new ArgumentOutOfRangeException(nameof(step), step, "A etapa deve estar entre 1 e 8.");

    public static int Percentage(IReadOnlyCollection<int> completedSteps) =>
        (int)Math.Round(completedSteps.Distinct().Count(step => step is >= 1 and <= TotalSteps) * 100d / TotalSteps);
}
