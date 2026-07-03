using IntegraRP.Domain.Studio;
using Xunit;

namespace IntegraRP.Tests;

public sealed class Sprint9StudioAdvancedTests
{
    [Fact]
    public void Migration_0009_Deve_Existir_E_Usar_Somente_Integrarp()
    {
        var path = Path.Combine("..", "..", "..", "..", "database", "migrations", "0009_studio_avancado_modulos_dinamicos.sql");
        Assert.True(File.Exists(path));
        var sql = File.ReadAllText(path);
        Assert.DoesNotContain("public.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("integra.", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.modulo_dinamico", sql, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("integrarp.modulo_registro", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Theory]
    [InlineData("modulo_dinamico")]
    [InlineData("modulo_entidade")]
    [InlineData("modulo_campo")]
    [InlineData("modulo_acao")]
    [InlineData("modulo_menu")]
    [InlineData("modulo_permissao")]
    [InlineData("modulo_relacionamento")]
    [InlineData("modulo_kpi")]
    [InlineData("modulo_bpmn_vinculo")]
    [InlineData("modulo_catalogo_semantico")]
    [InlineData("modulo_registro")]
    [InlineData("modulo_registro_valor")]
    public void Migration_Deve_Conter_Tabelas_Studio(string table)
    {
        var path = Path.Combine("..", "..", "..", "..", "database", "migrations", "0009_studio_avancado_modulos_dinamicos.sql");
        var sql = File.ReadAllText(path);
        Assert.Contains($"integrarp.{table}", sql, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void Modulo_Sem_Nome_Deve_Falhar()
    {
        Assert.Throws<ArgumentException>(() => new DynamicModule(Guid.NewGuid(), "", "codigo", "slug"));
    }

    [Fact]
    public void Modulo_Sem_Entidade_Principal_Nao_Publica()
    {
        var module = new DynamicModule(Guid.NewGuid(), "Teste", "teste", "teste");
        Assert.Throws<InvalidOperationException>(() => module.Publish());
    }

    [Fact]
    public void Campo_Select_Sem_Opcoes_Deve_Falhar()
    {
        Assert.Throws<InvalidOperationException>(() => new DynamicField(Guid.NewGuid(), "Status", "status", "Status", DynamicFieldType.Select, true, true));
    }

    [Fact]
    public void Campo_Relation_Sem_Destino_Deve_Falhar()
    {
        Assert.Throws<InvalidOperationException>(() => new DynamicField(Guid.NewGuid(), "Cliente", "cliente", "Cliente", DynamicFieldType.Relation, false, true));
    }

    [Fact]
    public void Campo_Sensivel_Exige_Mascaramento()
    {
        Assert.Throws<InvalidOperationException>(() => new DynamicField(Guid.NewGuid(), "CPF", "cpf", "CPF", DynamicFieldType.Text, true, true, true, false));
    }

    [Fact]
    public void Acao_StartWorkflow_Sem_Bpmn_Deve_Falhar()
    {
        Assert.Throws<InvalidOperationException>(() => new DynamicAction(Guid.NewGuid(), "Iniciar", "iniciar", DynamicActionType.StartWorkflow));
    }

    [Fact]
    public void Modulo_Publicado_Com_Regras_Minimas_Deve_Publicar()
    {
        var tenantId = Guid.NewGuid();
        var module = new DynamicModule(tenantId, "Controle", "controle", "controle");
        module.AddEntity(new DynamicEntity(tenantId, "Ocorrência", "ocorrencia"));
        module.AddField(new DynamicField(tenantId, "Descrição", "descricao", "Descrição", DynamicFieldType.TextArea, true, true));
        module.AddAction(new DynamicAction(tenantId, "Abrir", "abrir", DynamicActionType.Open));
        module.Publish();
        Assert.Equal(DynamicModuleStatus.Published, module.Status);
    }
}
