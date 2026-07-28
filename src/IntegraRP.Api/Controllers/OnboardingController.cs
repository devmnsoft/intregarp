using IntegraRP.Application.Onboarding;
using IntegraRP.Contracts.Onboarding;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/onboarding")]
public sealed class OnboardingController(
    GetOnboardingStateUseCase getState,
    UpdateOnboardingStepUseCase updateStep,
    DismissOnboardingUseCase dismiss,
    ReconcileOnboardingProgressUseCase reconcile,
    ReopenOnboardingUseCase reopen) : ControllerBase
{
    private Guid RequiredClaim(string name) => Guid.TryParse(User.FindFirst(name)?.Value, out var value)
        ? value : throw new UnauthorizedAccessException($"Claim obrigatória ausente: {name}.");

    [HttpGet]
    public Task<OnboardingStateDto> Get(CancellationToken cancellationToken) =>
        getState.ExecuteAsync(RequiredClaim("tenant_id"), RequiredClaim("sub"), cancellationToken);

    [HttpPut("step")]
    public Task<OnboardingStateDto> Update(UpdateOnboardingStepRequest request, CancellationToken cancellationToken) =>
        updateStep.ExecuteAsync(RequiredClaim("tenant_id"), RequiredClaim("sub"), request, cancellationToken);

    [HttpPost("dismiss")]
    public Task<OnboardingStateDto> Dismiss(DismissOnboardingRequest request, CancellationToken cancellationToken) =>
        dismiss.ExecuteAsync(RequiredClaim("tenant_id"), RequiredClaim("sub"), request, cancellationToken);

    [HttpPost("reconcile")]
    public Task<OnboardingStateDto> Reconcile(CancellationToken cancellationToken) =>
        reconcile.ExecuteAsync(RequiredClaim("tenant_id"), RequiredClaim("sub"), cancellationToken);

    [HttpPost("reopen")]
    public Task<OnboardingStateDto> Reopen(ReopenOnboardingRequest request, CancellationToken cancellationToken) =>
        reopen.ExecuteAsync(RequiredClaim("tenant_id"), RequiredClaim("sub"), request, cancellationToken);
}
