using IntegraRP.Application.Common;
using IntegraRP.Domain.Journey;

namespace IntegraRP.Application.Abstractions.Journey;

public sealed record JourneyRequest(Guid TenantId, Guid UserId, string? Code = null, Guid? Id = null, string? ScreenKey = null);
public sealed record WhatToDoNowItem(string Title, string Description, string Priority, string? Route);

public interface ICustomerJourneyRepository { Task<IReadOnlyCollection<CustomerJourney>> ListAsync(Guid tenantId, CancellationToken cancellationToken); Task<CustomerJourney?> GetAsync(Guid tenantId, string code, CancellationToken cancellationToken); }
public interface IUserJourneyProgressRepository { Task<UserJourneyProgress?> GetAsync(Guid tenantId, Guid userId, string code, CancellationToken cancellationToken); Task SaveAsync(UserJourneyProgress progress, CancellationToken cancellationToken); }
public interface IRecommendedActionRepository { Task<IReadOnlyCollection<RecommendedAction>> ListAsync(Guid tenantId, Guid? userId, CancellationToken cancellationToken); Task<RecommendedAction?> GetAsync(Guid tenantId, Guid id, CancellationToken cancellationToken); Task SaveAsync(RecommendedAction action, CancellationToken cancellationToken); }
public interface IContextualHelpRepository { Task<ContextualTip?> GetAsync(Guid tenantId, string screenKey, CancellationToken cancellationToken); }
public interface IGuidedTourRepository { Task<GuidedTour?> GetAsync(Guid tenantId, string code, CancellationToken cancellationToken); }
public interface IEmptyStateGuidanceRepository { Task<EmptyStateGuidance?> GetAsync(Guid tenantId, string screenKey, CancellationToken cancellationToken); }

public interface ICustomerJourneyService { Task<Result<IReadOnlyCollection<CustomerJourney>>> ListAsync(JourneyRequest request, CancellationToken cancellationToken); Task<Result<CustomerJourney>> StartAsync(JourneyRequest request, CancellationToken cancellationToken); }
public interface IRecommendedActionService { Task<Result<IReadOnlyCollection<RecommendedAction>>> ListAsync(JourneyRequest request, CancellationToken cancellationToken); Task<Result<RecommendedAction>> CompleteAsync(JourneyRequest request, CancellationToken cancellationToken); }
public interface IWhatToDoNowService { Task<Result<IReadOnlyCollection<WhatToDoNowItem>>> GetAsync(JourneyRequest request, CancellationToken cancellationToken); }
public interface IContextualHelpService { Task<Result<ContextualTip>> GetAsync(JourneyRequest request, CancellationToken cancellationToken); }
public interface IGuidedTourService { Task<Result<GuidedTour>> GetAsync(JourneyRequest request, CancellationToken cancellationToken); }
public interface IEmptyStateService { Task<Result<EmptyStateGuidance>> GetAsync(JourneyRequest request, CancellationToken cancellationToken); }
public interface IUserOnboardingService { Task<Result<UserJourneyProgress>> GetProgressAsync(JourneyRequest request, CancellationToken cancellationToken); }
