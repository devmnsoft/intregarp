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
        return Problem(
            title: "Erro interno",
            detail: "Não foi possível concluir a operação. Informe o correlation_id ao suporte.",
            statusCode: StatusCodes.Status500InternalServerError,
            extensions: new Dictionary<string, object?> { ["code"] = "internal_error", ["correlation_id"] = HttpContext.TraceIdentifier });
    }
}
