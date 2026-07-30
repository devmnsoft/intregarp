using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Journey;

public sealed class PostgresJourneyRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresJourneyRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.jornada_usuario_progresso")
{
}
