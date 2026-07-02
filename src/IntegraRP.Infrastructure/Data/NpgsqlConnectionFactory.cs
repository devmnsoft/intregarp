using System.Data;
using Microsoft.Extensions.Configuration;
using Npgsql;

namespace IntegraRP.Infrastructure.Data;

public sealed class NpgsqlConnectionFactory(IConfiguration configuration) : IDbConnectionFactory
{
    public async Task<IDbConnection> OpenConnectionAsync(CancellationToken cancellationToken)
    {
        var connectionString = configuration.GetConnectionString("IntegraRP")
            ?? throw new InvalidOperationException("ConnectionStrings:IntegraRP não configurada.");
        var connection = new NpgsqlConnection(connectionString);
        await connection.OpenAsync(cancellationToken);
        return connection;
    }
}
