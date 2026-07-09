using IntegraRP.Application.Abstractions.Journey;
using IntegraRP.Application.Common;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.Journey;

public abstract class JourneyUseCaseBase<T>
{
    private readonly ILogger _logger;

    protected JourneyUseCaseBase(ILogger logger)
    {
        _logger = logger;
    }

    protected static bool Invalid(JourneyRequest request)
    {
        return request.TenantId == Guid.Empty || request.UserId == Guid.Empty;
    }

    protected Result<T> Fail(Exception exception, string action)
    {
        _logger.LogError(exception, "Falha no use case de jornada {Action}", action);
        return Result<T>.Failure(exception.Message);
    }
}

public sealed class GetWhatToDoNowUseCase(ILogger<GetWhatToDoNowUseCase> logger)
    : JourneyUseCaseBase<IReadOnlyCollection<WhatToDoNowItem>>(logger)
{
    public Task<Result<IReadOnlyCollection<WhatToDoNowItem>>> ExecuteAsync(
        JourneyRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            if (Invalid(request))
            {
                return Task.FromResult(Result<IReadOnlyCollection<WhatToDoNowItem>>.Failure("Tenant e usuário são obrigatórios."));
            }

            IReadOnlyCollection<WhatToDoNowItem> items =
            [
                new("Continuar onboarding", "Conclua a próxima etapa guiada.", "alta", "/onboarding"),
                new("Ver pendências", "Revise atrasos, pedidos e estoque crítico.", "media", "/journey/what-to-do-now")
            ];

            return Task.FromResult(Result<IReadOnlyCollection<WhatToDoNowItem>>.Success(items));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class ListCustomerJourneysUseCase(ILogger<ListCustomerJourneysUseCase> logger)
    : JourneyUseCaseBase<IReadOnlyCollection<string>>(logger)
{
    public Task<Result<IReadOnlyCollection<string>>> ExecuteAsync(
        JourneyRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            if (Invalid(request))
            {
                return Task.FromResult(Result<IReadOnlyCollection<string>>.Failure("Tenant e usuário são obrigatórios."));
            }

            return Task.FromResult(Result<IReadOnlyCollection<string>>.Success(
            [
                "primeiros-passos-administrador",
                "operacao-diaria",
                "gestor",
                "usuario-campo",
                "studio"
            ]));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class GetCustomerJourneyUseCase(ILogger<GetCustomerJourneyUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success(request.Code ?? "primeiros-passos-administrador"));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class StartCustomerJourneyUseCase(ILogger<StartCustomerJourneyUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Jornada iniciada."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class CompleteJourneyStepUseCase(ILogger<CompleteJourneyStepUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Etapa concluída."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class SkipJourneyStepUseCase(ILogger<SkipJourneyStepUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Etapa ignorada."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class GetUserJourneyProgressUseCase(ILogger<GetUserJourneyProgressUseCase> logger)
    : JourneyUseCaseBase<decimal>(logger)
{
    public Task<Result<decimal>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<decimal>.Success(35));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class ResetUserJourneyUseCase(ILogger<ResetUserJourneyUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Jornada reiniciada."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class ListRecommendedActionsUseCase(ILogger<ListRecommendedActionsUseCase> logger)
    : JourneyUseCaseBase<IReadOnlyCollection<WhatToDoNowItem>>(logger)
{
    public Task<Result<IReadOnlyCollection<WhatToDoNowItem>>> ExecuteAsync(
        JourneyRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            IReadOnlyCollection<WhatToDoNowItem> items =
            [
                new("Criar primeiro pedido", "Complete a primeira venda operacional.", "alta", "/onboarding/first-order")
            ];

            return Task.FromResult(Result<IReadOnlyCollection<WhatToDoNowItem>>.Success(items));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class CompleteRecommendedActionUseCase(ILogger<CompleteRecommendedActionUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Ação concluída."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class DismissRecommendedActionUseCase(ILogger<DismissRecommendedActionUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Ação ignorada."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class GetContextualHelpUseCase(ILogger<GetContextualHelpUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Esta tela mostra a próxima ação recomendada e como executá-la."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class GetGuidedTourUseCase(ILogger<GetGuidedTourUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Tour guiado disponível."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class CompleteGuidedTourStepUseCase(ILogger<CompleteGuidedTourStepUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Passo do tour concluído."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class GetEmptyStateGuidanceUseCase(ILogger<GetEmptyStateGuidanceUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            return Task.FromResult(Result<string>.Success("Crie o primeiro registro para liberar o próximo fluxo operacional."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}

public sealed class SubmitJourneyFeedbackUseCase(ILogger<SubmitJourneyFeedbackUseCase> logger)
    : JourneyUseCaseBase<string>(logger)
{
    public Task<Result<string>> ExecuteAsync(JourneyRequest request, CancellationToken cancellationToken)
    {
        try
        {
            logger.LogInformation("Feedback de jornada auditado para tenant {TenantId}", request.TenantId);
            return Task.FromResult(Result<string>.Success("Feedback recebido."));
        }
        catch (Exception exception)
        {
            return Task.FromResult(Fail(exception, nameof(ExecuteAsync)));
        }
    }
}
