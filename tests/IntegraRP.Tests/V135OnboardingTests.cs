using IntegraRP.Domain.Onboarding;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V135OnboardingTests
{
    [Fact]
    public void PercentageCountsOnlyDistinctValidSteps()
    {
        Assert.Equal(25, OnboardingProgress.Percentage([1, 1, 2, 99]));
    }

    [Theory]
    [InlineData(0, 1)]
    [InlineData(4, 4)]
    [InlineData(9, 8)]
    public void NormalizeStepKeepsProgressInsideJourney(int input, int expected)
    {
        Assert.Equal(expected, OnboardingProgress.NormalizeStep(input));
    }
}
