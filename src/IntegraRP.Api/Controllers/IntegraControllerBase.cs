using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

public abstract class IntegraControllerBase : ControllerBase
{
    protected Guid TenantId => Guid.TryParse(Request.Headers["x-tenant-id"], out var tenantId) ? tenantId : Guid.Parse("00000000-0000-0000-0000-000000000001");

    protected ObjectResult ProblemFrom(Exception exception, ILogger logger, string context)
    {
        logger.LogError(exception, "Erro em {Context}", context);
        return Problem(title: "Erro interno", detail: exception.Message, statusCode: StatusCodes.Status500InternalServerError);
    }
}
