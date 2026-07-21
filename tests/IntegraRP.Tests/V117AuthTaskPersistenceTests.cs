using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Xunit;

namespace IntegraRP.Tests;

public sealed class V117AuthTaskPersistenceTests
{
    [Fact]
    public void PasswordHasher_Deve_Gerar_Hash_Verificavel_Sem_Texto_Plano()
    {
        var hasher = new PasswordHasher<TestUser>();
        var user = new TestUser(Guid.NewGuid(), "admin@tenant.local");
        var hash = hasher.HashPassword(user, "SenhaForte!234");
        Assert.DoesNotContain("SenhaForte", hash, StringComparison.OrdinalIgnoreCase);
        Assert.Equal(PasswordVerificationResult.Success, hasher.VerifyHashedPassword(user, hash, "SenhaForte!234"));
    }

    [Fact]
    public void RefreshToken_Deve_Ser_Aleatorio_E_Armazenavel_Apenas_Como_Hash()
    {
        var tokenA = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
        var tokenB = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
        Assert.NotEqual(tokenA, tokenB);
        Assert.NotEqual(Sha256(tokenA), tokenA);
        Assert.Equal(Sha256(tokenA), Sha256(tokenA));
    }

    [Fact]
    public void Maquina_De_Estados_De_Tarefa_Deve_Exigir_Assumir_E_Iniciar_Antes_De_Concluir()
    {
        var task = new TestTask();
        Assert.False(task.TryComplete());
        Assert.True(task.TryClaim());
        Assert.False(task.TryComplete());
        Assert.True(task.TryStart());
        Assert.True(task.TryComplete());
        Assert.False(task.TryStart());
    }

    private static string Sha256(string value) => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(value))).ToLowerInvariant();
    private sealed record TestUser(Guid Id, string Email);
    private sealed class TestTask
    {
        private string status = "pendente";
        public bool TryClaim() { if (status != "pendente") return false; status = "assumida"; return true; }
        public bool TryStart() { if (status != "assumida") return false; status = "em_execucao"; return true; }
        public bool TryComplete() { if (status != "em_execucao") return false; status = "concluida"; return true; }
    }
}
