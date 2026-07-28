using Microsoft.AspNetCore.Mvc;
using System.Data;
using IntegraRP.Application.Common;

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
                ValidationException => (StatusCodes.Status400BadRequest, "Solicitação inválida", ex.Message),
                NotFoundException => (StatusCodes.Status404NotFound, "Recurso não encontrado", ex.Message),
                ConflictException => (StatusCodes.Status409Conflict, "Conflito", ex.Message),
                ConcurrencyException => (StatusCodes.Status409Conflict, "Atualização concorrente", "Os dados mudaram em outra sessão. Atualize a página e tente novamente."),
                DBConcurrencyException => (StatusCodes.Status409Conflict, "Atualização concorrente", "Os dados mudaram em outra sessão. Atualize a página e tente novamente."),
                BusinessRuleException => (StatusCodes.Status422UnprocessableEntity, "Regra de negócio", ex.Message),
                ForbiddenException => (StatusCodes.Status403Forbidden, "Acesso negado", ex.Message),
                DependencyUnavailableException => (StatusCodes.Status503ServiceUnavailable, "Serviço indisponível", ex.Message),
                UnauthorizedContextException => (StatusCodes.Status401Unauthorized, "Autenticação necessária", "Entre novamente para continuar."),
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
