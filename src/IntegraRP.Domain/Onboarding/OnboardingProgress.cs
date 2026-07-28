namespace IntegraRP.Domain.Onboarding;

public static class OnboardingProgress
{
    public const int TotalSteps = 8;

    public static int NormalizeStep(int step) => Math.Clamp(step, 1, TotalSteps);

    public static int Percentage(IReadOnlyCollection<int> completedSteps) =>
        (int)Math.Round(completedSteps.Distinct().Count(step => step is >= 1 and <= TotalSteps) * 100d / TotalSteps);
}
