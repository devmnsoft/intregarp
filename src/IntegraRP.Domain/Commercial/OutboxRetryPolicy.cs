namespace IntegraRP.Domain.Commercial;

public sealed class OutboxRetryPolicy(int maximumAttempts, TimeSpan initialDelay, TimeSpan maximumDelay)
{
    public int MaximumAttempts { get; } = maximumAttempts > 0 ? maximumAttempts : throw new ArgumentOutOfRangeException(nameof(maximumAttempts));
    public TimeSpan NextDelay(int attempts)
    {
        if (attempts < 0) throw new ArgumentOutOfRangeException(nameof(attempts));
        var multiplier = Math.Pow(2, Math.Min(attempts, 20));
        return TimeSpan.FromMilliseconds(Math.Min(maximumDelay.TotalMilliseconds, initialDelay.TotalMilliseconds * multiplier));
    }
    public bool IsDeadLetter(int attempts) => attempts >= MaximumAttempts;
}
