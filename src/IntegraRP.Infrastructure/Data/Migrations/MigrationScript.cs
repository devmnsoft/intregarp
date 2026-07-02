using System.Security.Cryptography;
using System.Text;

namespace IntegraRP.Infrastructure.Data.Migrations;

public sealed record MigrationScript(string Name, string FullPath, string Sql)
{
    public string ChecksumSha256 => CalculateChecksum(Sql);

    public static string CalculateChecksum(string content) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(content)));
}
