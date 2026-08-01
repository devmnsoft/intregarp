using IntegraRP.Api.Security;
using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

public abstract class IntegraControllerBase : ControllerBase
{
    protected Guid TenantId
    {
        get
        {
            if (HttpContext.Items.TryGetValue("tenant_id", out var value) && value is Guid tenantId) return tenantId;
            return Guid.Empty;
        }
    }

    protected ObjectResult ProblemFrom(Exception exception, ILogger logger, string context)
    {
        logger.LogError(exception, "Erro em {Context}. CorrelationId={CorrelationId}", context, HttpContext.TraceIdentifier);
        var details = new ProblemDetails
        {
            Status = StatusCodes.Status500InternalServerError,
            Title = "Erro interno",
            Detail = "Não foi possível concluir a operação. Informe o correlation_id ao suporte.",
            Type = "https://httpstatuses.com/500",
            Instance = HttpContext.Request.Path
        };
        details.Extensions["code"] = "internal_error";
        details.Extensions["correlation_id"] = HttpContext.TraceIdentifier;

        return new ObjectResult(details)
        {
            StatusCode = details.Status,
            ContentTypes = { "application/problem+json" }
        };
    }
}
