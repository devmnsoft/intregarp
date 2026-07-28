using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using IntegraRP.Contracts.Onboarding;
using IntegraRP.Web.Services.Identity;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Services.Onboarding;

public interface IOnboardingApiClient
{
    Task<OnboardingStateDto> GetAsync(CancellationToken cancellationToken);
    Task<OnboardingStateDto> ReconcileAsync(CancellationToken cancellationToken);
    Task<OnboardingStateDto> DismissAsync(long rowVersion, CancellationToken cancellationToken);
    Task<OnboardingStateDto> ReopenAsync(long rowVersion, CancellationToken cancellationToken);
}

public sealed class OnboardingApiClient(HttpClient client, IHttpContextAccessor contextAccessor, IIdentitySessionStore sessions) : IOnboardingApiClient
{
    public Task<OnboardingStateDto> GetAsync(CancellationToken ct) => SendAsync(HttpMethod.Get, "/api/onboarding", null, ct);
    public Task<OnboardingStateDto> ReconcileAsync(CancellationToken ct) => SendAsync(HttpMethod.Post, "/api/onboarding/reconcile", null, ct);
    public Task<OnboardingStateDto> DismissAsync(long rowVersion, CancellationToken ct) => SendAsync(HttpMethod.Post, "/api/onboarding/dismiss", new DismissOnboardingRequest(rowVersion), ct);
    public Task<OnboardingStateDto> ReopenAsync(long rowVersion, CancellationToken ct) => SendAsync(HttpMethod.Post, "/api/onboarding/reopen", new ReopenOnboardingRequest(rowVersion), ct);

    private async Task<OnboardingStateDto> SendAsync(HttpMethod method, string path, object? body, CancellationToken ct)
    {
        var httpContext = contextAccessor.HttpContext ?? throw new InvalidOperationException("Contexto Web indisponível.");
        var sessionId = httpContext.User.FindFirst("session_id")?.Value;
        var tokens = sessionId is null ? null : await sessions.GetAsync(sessionId, ct);
        if (tokens is null) throw new OnboardingApiException(HttpStatusCode.Unauthorized, "Sua sessão expirou.", httpContext.TraceIdentifier);
        using var request = new HttpRequestMessage(method, path);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", tokens.AccessToken);
        request.Headers.TryAddWithoutValidation("X-Correlation-ID", httpContext.TraceIdentifier);
        if (body is not null) request.Content = JsonContent.Create(body);
        using var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, ct);
        if (response.IsSuccessStatusCode)
            return await response.Content.ReadFromJsonAsync<OnboardingStateDto>(cancellationToken: ct)
                ?? throw new OnboardingApiException(HttpStatusCode.ServiceUnavailable, "A API retornou uma resposta vazia.", httpContext.TraceIdentifier);
        var problem = await response.Content.ReadFromJsonAsync<ProblemDetails>(cancellationToken: ct);
        throw new OnboardingApiException(response.StatusCode, problem?.Detail ?? problem?.Title ?? "Não foi possível carregar os primeiros passos.", httpContext.TraceIdentifier);
    }
}

public sealed class OnboardingApiException(HttpStatusCode statusCode, string message, string correlationId) : Exception(message)
{
    public HttpStatusCode StatusCode { get; } = statusCode;
    public string CorrelationId { get; } = correlationId;
}
