using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace IntegraRP.Api.Middlewares;

public sealed class GlobalExceptionMiddleware(RequestDelegate next, ILogger<GlobalExceptionMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await next(context);
        }
        catch (Exception ex)
        {
            var correlationId = context.TraceIdentifier;
            logger.LogError(ex, "Erro não tratado. CorrelationId={CorrelationId}", correlationId);
            var (status, title, detail) = ex switch
            {
                ArgumentException => (StatusCodes.Status400BadRequest, "Solicitação inválida", ex.Message),
                DBConcurrencyException => (StatusCodes.Status409Conflict, "Atualização concorrente", "Os dados mudaram em outra sessão. Atualize a página e tente novamente."),
                UnauthorizedAccessException => (StatusCodes.Status401Unauthorized, "Autenticação necessária", "Entre novamente para continuar."),
                _ => (StatusCodes.Status500InternalServerError, "Erro interno no IntegraRP", "Ocorreu uma falha inesperada. Informe o correlation_id ao suporte.")
            };
            context.Response.StatusCode = status;
            await context.Response.WriteAsJsonAsync(new ProblemDetails
            {
                Title = title,
                Detail = detail,
                Status = status,
                Extensions = { ["correlation_id"] = correlationId }
            });
        }
    }
}
