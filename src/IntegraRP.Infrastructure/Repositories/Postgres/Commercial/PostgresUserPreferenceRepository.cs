using System.Data;
using System.Text.Json;
using Dapper;
using IntegraRP.Application.Onboarding;
using IntegraRP.Contracts.Onboarding;
using IntegraRP.Domain.Onboarding;
using IntegraRP.Infrastructure.Data;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Commercial;

public sealed class PostgresUserPreferenceRepository(IDbConnectionFactory connectionFactory) : IUserPreferenceRepository
{
    private const string Key = "onboarding.v135";

    public async Task<OnboardingStateDto> GetOnboardingAsync(Guid tenantId, Guid userId, CancellationToken cancellationToken)
    {
        ValidateContext(tenantId, userId);
        using var connection = await connectionFactory.OpenConnectionAsync(cancellationToken);
        var row = await connection.QuerySingleOrDefaultAsync<Row>(new CommandDefinition(
            "select valor::text Value, atualizado_em UpdatedAt, row_version RowVersion from integrarp.usuario_preferencia where tenant_id=@tenantId and usuario_id=@userId and chave=@Key",
            new { tenantId, userId, Key }, cancellationToken: cancellationToken));
        return row is null ? Empty() : Map(row);
    }

    public Task<OnboardingStateDto> UpdateOnboardingStepAsync(Guid tenantId, Guid userId, UpdateOnboardingStepRequest request, CancellationToken cancellationToken) =>
        MutateAsync(tenantId, userId, request.RowVersion, state =>
        {
            var step = OnboardingProgress.NormalizeStep(request.Step);
            if (request.Completed) state.CompletedSteps.Add(step); else state.CompletedSteps.Remove(step);
            state.CurrentStep = request.Completed ? Math.Min(step + 1, OnboardingProgress.TotalSteps) : step;
            state.Dismissed = false;
            state.Completed = state.CompletedSteps.Count == OnboardingProgress.TotalSteps;
        }, cancellationToken);

    public Task<OnboardingStateDto> DismissOnboardingAsync(Guid tenantId, Guid userId, DismissOnboardingRequest request, CancellationToken cancellationToken) =>
        MutateAsync(tenantId, userId, request.RowVersion, state => state.Dismissed = true, cancellationToken);

    private async Task<OnboardingStateDto> MutateAsync(Guid tenantId, Guid userId, long expectedVersion, Action<State> mutate, CancellationToken cancellationToken)
    {
        ValidateContext(tenantId, userId);
        using var connection = await connectionFactory.OpenConnectionAsync(cancellationToken);
        using var transaction = connection.BeginTransaction();
        var row = await connection.QuerySingleOrDefaultAsync<Row>(new CommandDefinition(
            "select valor::text Value, atualizado_em UpdatedAt, row_version RowVersion from integrarp.usuario_preferencia where tenant_id=@tenantId and usuario_id=@userId and chave=@Key for update",
            new { tenantId, userId, Key }, transaction, cancellationToken: cancellationToken));
        if (row is not null && row.RowVersion != expectedVersion) throw new DBConcurrencyException("O onboarding foi atualizado em outra sessão.");
        if (row is null && expectedVersion != 0) throw new DBConcurrencyException("A versão inicial do onboarding deve ser zero.");
        var state = row is null ? new State() : JsonSerializer.Deserialize<State>(row.Value) ?? new State();
        mutate(state);
        var value = JsonSerializer.Serialize(state);
        var updated = await connection.QuerySingleAsync<Row>(new CommandDefinition("""
            insert into integrarp.usuario_preferencia(id,tenant_id,usuario_id,chave,valor,criado_em,atualizado_em,row_version)
            values(gen_random_uuid(),@tenantId,@userId,@Key,@value::jsonb,now(),now(),1)
            on conflict(tenant_id,usuario_id,chave) do update set valor=excluded.valor,atualizado_em=now(),row_version=integrarp.usuario_preferencia.row_version+1
            returning valor::text Value, atualizado_em UpdatedAt, row_version RowVersion
            """, new { tenantId, userId, Key, value }, transaction, cancellationToken: cancellationToken));
        transaction.Commit();
        return Map(updated);
    }

    private static OnboardingStateDto Map(Row row)
    {
        var state = JsonSerializer.Deserialize<State>(row.Value) ?? new State();
        return new(state.CurrentStep, state.CompletedSteps.Order().ToArray(), state.Dismissed, state.Completed,
            OnboardingProgress.Percentage(state.CompletedSteps), row.UpdatedAt, row.RowVersion);
    }

    private static OnboardingStateDto Empty() => new(1, [], false, false, 0, DateTimeOffset.UtcNow, 0);
    private static void ValidateContext(Guid tenantId, Guid userId) { if (tenantId == Guid.Empty || userId == Guid.Empty) throw new UnauthorizedAccessException("Contexto autenticado obrigatório."); }
    private sealed record Row(string Value, DateTimeOffset UpdatedAt, long RowVersion);
    private sealed class State { public int CurrentStep { get; set; } = 1; public HashSet<int> CompletedSteps { get; set; } = []; public bool Dismissed { get; set; } public bool Completed { get; set; } }
}
