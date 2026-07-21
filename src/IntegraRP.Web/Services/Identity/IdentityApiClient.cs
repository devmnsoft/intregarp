using System.Net;
using System.Net.Http.Json;
using IntegraRP.Application.Auth;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Web.Services.Identity;

public sealed class IdentityApiClient(HttpClient httpClient) : IIdentityApiClient
{
    public async Task<AuthResponse> LoginAsync(LoginRequest request, CancellationToken cancellationToken) =>
        await SendAsync<AuthResponse>(HttpMethod.Post, "/api/auth/login", request, cancellationToken);

    public async Task<AuthResponse> RefreshAsync(string refreshToken, CancellationToken cancellationToken) =>
        await SendAsync<AuthResponse>(HttpMethod.Post, "/api/auth/refresh", new RefreshRequest(refreshToken), cancellationToken);

    public async Task LogoutAsync(Guid? sessionId, bool allSessions, CancellationToken cancellationToken) =>
        await SendNoContentAsync(HttpMethod.Post, "/api/auth/logout", new LogoutRequest(sessionId, allSessions), cancellationToken);

    public async Task<IReadOnlyList<AuthSessionDto>> ListSessionsAsync(CancellationToken cancellationToken) =>
        await SendAsync<IReadOnlyList<AuthSessionDto>>(HttpMethod.Get, "/api/auth/sessions", null, cancellationToken);

    public Task RevokeSessionAsync(Guid sessionId, CancellationToken cancellationToken) =>
        SendNoContentAsync(HttpMethod.Delete, $"/api/auth/sessions/{sessionId}", null, cancellationToken);

    public Task ForgotPasswordAsync(ForgotPasswordRequest request, CancellationToken cancellationToken) =>
        SendNoContentOrAcceptedAsync("/api/auth/forgot-password", request, cancellationToken);

    public Task ResetPasswordAsync(ResetPasswordRequest request, CancellationToken cancellationToken) =>
        SendNoContentOrAcceptedAsync("/api/auth/reset-password", request, cancellationToken);

    private async Task<T> SendAsync<T>(HttpMethod method, string path, object? body, CancellationToken ct)
    {
        using var response = await SendRawAsync(method, path, body, ct);
        if (response.IsSuccessStatusCode)
        {
            return await response.Content.ReadFromJsonAsync<T>(cancellationToken: ct) ?? throw new InvalidOperationException("Resposta vazia da API de identidade.");
        }
        throw await CreateExceptionAsync(response, ct);
    }

    private async Task SendNoContentAsync(HttpMethod method, string path, object? body, CancellationToken ct)
    {
        using var response = await SendRawAsync(method, path, body, ct);
        if (!response.IsSuccessStatusCode) throw await CreateExceptionAsync(response, ct);
    }

    private async Task SendNoContentOrAcceptedAsync(string path, object body, CancellationToken ct)
    {
        using var response = await SendRawAsync(HttpMethod.Post, path, body, ct);
        if (!response.IsSuccessStatusCode) throw await CreateExceptionAsync(response, ct);
    }

    private async Task<HttpResponseMessage> SendRawAsync(HttpMethod method, string path, object? body, CancellationToken ct)
    {
        using var request = new HttpRequestMessage(method, path);
        if (body is not null) request.Content = JsonContent.Create(body);
        return await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, ct);
    }

    private static async Task<IdentityApiException> CreateExceptionAsync(HttpResponseMessage response, CancellationToken ct)
    {
        ProblemDetails? problem = null;
        try { problem = await response.Content.ReadFromJsonAsync<ProblemDetails>(cancellationToken: ct); } catch { }
        return new IdentityApiException(response.StatusCode, problem?.Title ?? "Falha na API de identidade.", problem?.Extensions.TryGetValue("correlation_id", out var c) == true ? c?.ToString() : null);
    }
}

public sealed class IdentityApiException(HttpStatusCode statusCode, string message, string? correlationId) : Exception(message)
{
    public HttpStatusCode StatusCode { get; } = statusCode;
    public string? CorrelationId { get; } = correlationId;
}
