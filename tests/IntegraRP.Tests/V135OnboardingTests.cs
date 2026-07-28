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

    [Fact]
    public void RequireValidStepKeepsValidProgressInsideJourney()
    {
        Assert.Equal(4, OnboardingProgress.RequireValidStep(4));
    }

    [Theory]
    [InlineData(0)]
    [InlineData(9)]
    public void RequireValidStepRejectsValuesOutsideJourney(int input)
    {
        Assert.Throws<ArgumentOutOfRangeException>(() => OnboardingProgress.RequireValidStep(input));
    }
}
