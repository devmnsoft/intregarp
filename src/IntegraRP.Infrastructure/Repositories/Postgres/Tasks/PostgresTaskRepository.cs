using Microsoft.Extensions.Logging;
using IntegraRP.Infrastructure.Repositories.Postgres;

namespace IntegraRP.Infrastructure.Repositories.Postgres.Tasks;

public sealed class PostgresTaskRepository(PostgresConnectionFactory connectionFactory, ILogger<PostgresTaskRepository> logger)
    : DomainCrudRepository(connectionFactory, logger, "integrarp.tarefa")
{
}
