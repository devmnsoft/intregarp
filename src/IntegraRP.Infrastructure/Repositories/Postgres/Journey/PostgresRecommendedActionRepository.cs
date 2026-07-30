using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Journey;

public sealed class PostgresRecommendedActionRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresRecommendedActionRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.jornada_acao_recomendada")
{
}
