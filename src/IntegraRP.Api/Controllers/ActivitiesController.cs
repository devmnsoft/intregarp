using Microsoft.AspNetCore.Mvc;

namespace IntegraRP.Api.Controllers;

[ApiController]
[Route("api/activities")]
public sealed class ActivitiesController(IConfiguration configuration, ILogger<ActivitiesController> logger) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        try
        {
            var rows = await V19Db.QueryAsync(configuration, @"
                SELECT a.codigo, a.titulo, a.descricao, a.modulo,
                       a.rota_web AS rotaWeb, a.rota_api AS rotaApi, a.icone, a.ordem,
                       a.perfil_recomendado AS perfilRecomendado,
                       COALESCE(a.metadata_json->>'permissao', a.metadata_json->>'permissao_requerida') AS permissao,
                       a.status, a.metadata_json AS metadataJson
                  FROM integrarp.atividade_operacional a
                  JOIN integrarp.tenant t ON t.id = a.tenant_id AND t.slug = 'demo'
                 WHERE a.excluido_em IS NULL
                 ORDER BY a.modulo, a.ordem, a.titulo;", cancellationToken);
            return Ok(rows);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Falha ao consultar integrarp.atividade_operacional");
            return Problem(ex.Message, statusCode: StatusCodes.Status503ServiceUnavailable, title: "Atividades reais indisponíveis");
        }
    }
}

internal static class DemoData
{
    public static readonly string[] DemoStepCodes = ["cliente", "produto", "estoque", "pedido", "confirmacao", "tarefa", "faturamento", "titulo", "boleto", "outbox", "dashboard", "jornada"];
}
