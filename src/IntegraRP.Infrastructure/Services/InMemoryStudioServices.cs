using IntegraRP.Application.Studio;
using IntegraRP.Contracts.Requests;
using IntegraRP.Contracts.Responses;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Infrastructure.Services;

public sealed class InMemoryStudioServices(ILogger<InMemoryStudioServices> logger) :
    IDynamicModuleRepository,
    IDynamicRecordRepository,
    IDynamicModuleBuilderService,
    IDynamicScreenGeneratorService,
    IDynamicModuleIntegrationService,
    IDynamicModuleSemanticCatalogService,
    ISmartModuleDraftService
{
    private readonly List<DynamicModuleResponse> modules = [];
    private readonly List<DynamicRecordResponse> records = [];

    public Task<IReadOnlyList<DynamicModuleResponse>> ListAsync(Guid tenantId, CancellationToken cancellationToken) => Task.FromResult<IReadOnlyList<DynamicModuleResponse>>(modules);

    public Task<DynamicModuleResponse> CreateAsync(Guid tenantId, CreateDynamicModuleRequest request, CancellationToken cancellationToken)
    {
        var module = new DynamicModuleResponse(Guid.NewGuid(), request.Nome, request.Codigo, request.Icone, request.Cor, []);
        modules.Add(module);
        logger.LogInformation("Módulo dinâmico {ModuleCode} criado", request.Codigo);
        return Task.FromResult(module);
    }

    public Task<IReadOnlyList<DynamicRecordResponse>> ListAsync(Guid tenantId, string moduleCode, CancellationToken cancellationToken) => Task.FromResult<IReadOnlyList<DynamicRecordResponse>>(records.Where(x => x.ModuleCode == moduleCode).ToArray());

    public Task<DynamicRecordResponse> CreateAsync(Guid tenantId, string moduleCode, UpsertDynamicRecordRequest request, CancellationToken cancellationToken)
    {
        var record = new DynamicRecordResponse(Guid.NewGuid(), moduleCode, request.Valores);
        records.Add(record);
        return Task.FromResult(record);
    }

    public Task<DynamicModuleResponse> AddFieldAsync(Guid tenantId, Guid moduleId, CreateDynamicFieldRequest request, CancellationToken cancellationToken)
    {
        var module = modules.FirstOrDefault(x => x.Id == moduleId) ?? new DynamicModuleResponse(moduleId, "Módulo", "modulo", "box", "#2563EB", []);
        var updated = module with { Campos = module.Campos.Concat([new DynamicFieldResponse(request.Nome, request.Codigo, request.Tipo, request.Obrigatorio)]).ToArray() };
        modules.RemoveAll(x => x.Id == moduleId);
        modules.Add(updated);
        return Task.FromResult(updated);
    }

    public string GenerateListScreenJson(DynamicModuleResponse module) => System.Text.Json.JsonSerializer.Serialize(new { module.Codigo, module.Campos }, new System.Text.Json.JsonSerializerOptions { WriteIndented = true });

    public Task BindWorkflowAsync(Guid tenantId, Guid moduleId, Guid processId, CancellationToken cancellationToken) => Task.CompletedTask;

    public Task RegisterAsync(Guid tenantId, Guid moduleId, string scope, CancellationToken cancellationToken) => Task.CompletedTask;

    public Task<SmartModuleDraftResponse> SuggestAsync(Guid tenantId, SmartModuleDraftRequest request, CancellationToken cancellationToken)
    {
        logger.LogInformation("Sugestão determinística de módulo solicitada para tenant {TenantId}", tenantId);
        var isDamage = request.Descricao.Contains("avaria", StringComparison.OrdinalIgnoreCase) || request.Descricao.Contains("devolução", StringComparison.OrdinalIgnoreCase);
        return Task.FromResult(new SmartModuleDraftResponse(
            isDamage ? "Controle de Avarias" : "Módulo Operacional",
            isDamage ? "exclamation-triangle" : "boxes",
            isDamage ? "#F59E0B" : "#2563EB",
            isDamage ? "Ocorrência de Avaria" : "Registro Operacional",
            [
                new("Cliente", "cliente", "Client", true),
                new("Produto", "produto", "Product", true),
                new("Lote", "lote", "Text", false),
                new("Quantidade", "quantidade", "Number", true),
                new("Tipo de avaria", "tipo_avaria", "Select", true),
                new("Foto", "foto", "Photo", false),
                new("Descrição", "descricao", "TextArea", true),
                new("Responsável", "responsavel", "User", true),
                new("Status", "status", "Select", true),
                new("Data da ocorrência", "data_ocorrencia", "Date", true)
            ],
            [
                new("Abrir ocorrência", "abrir", "Create"),
                new("Enviar para análise", "enviar_analise", "SendToAnalysis"),
                new("Aprovar", "aprovar", "Approve"),
                new("Reprovar", "reprovar", "Reject"),
                new("Gerar tarefa para estoque", "tarefa_estoque", "CreateTask"),
                new("Gerar tarefa para financeiro", "tarefa_financeiro", "CreateTask"),
                new("Iniciar processo de devolução", "iniciar_devolucao", "StartWorkflow")
            ],
            ["Total de avarias", "Avarias por produto", "Tempo médio de resolução", "Custo estimado"],
            "Ao criar avaria, iniciar processo Tratamento de Avaria e Devolução."));
    }
}
