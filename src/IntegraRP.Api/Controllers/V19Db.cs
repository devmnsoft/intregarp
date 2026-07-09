using Npgsql;

namespace IntegraRP.Api.Controllers;

internal static class V19Db
{
    public static string? GetConnectionString(IConfiguration configuration) =>
        configuration.GetConnectionString("IntegraRP") ??
        configuration["ConnectionStrings:IntegraRP"] ??
        configuration["ConnectionStrings__IntegraRP"];

    public static async Task<List<Dictionary<string, object?>>> QueryAsync(
        IConfiguration configuration,
        string sql,
        CancellationToken cancellationToken,
        params NpgsqlParameter[] parameters)
    {
        var connectionString = GetConnectionString(configuration);
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            throw new InvalidOperationException("ConnectionStrings__IntegraRP não configurada; não é possível retornar dados reais v1.9.");
        }

        await using var connection = new NpgsqlConnection(connectionString);
        await connection.OpenAsync(cancellationToken);
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddRange(parameters);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var rows = new List<Dictionary<string, object?>>();
        while (await reader.ReadAsync(cancellationToken))
        {
            var row = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);
            for (var i = 0; i < reader.FieldCount; i++)
            {
                row[reader.GetName(i)] = await reader.IsDBNullAsync(i, cancellationToken) ? null : reader.GetValue(i);
            }
            rows.Add(row);
        }
        return rows;
    }
}
