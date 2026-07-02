using IntegraRP.Application.Abstractions.Services;using IntegraRP.Application.Common;using IntegraRP.Contracts.Requests;using IntegraRP.Contracts.Responses;using Microsoft.Extensions.Logging;
namespace IntegraRP.Infrastructure.Services;
public sealed class SeededIntegraRpQueries(ILogger<SeededIntegraRpQueries> logger):IIntegraRpQueries{
static readonly Guid TenantId=Guid.Parse("11111111-1111-1111-1111-111111111111");
public Task<Result<DashboardResumoResponse>> DashboardAsync(CancellationToken ct)=>Ok(new DashboardResumoResponse(18,3,7,92,"Do pedido ao faturamento, tudo integrado, comunicado e medido."));
public Task<Result<IReadOnlyList<TenantResponse>>> TenantsAsync(CancellationToken ct)=>Ok<IReadOnlyList<TenantResponse>>([new(TenantId,"Valora Group & MNSoft","valora-mnsoft","Ativo")]);
public Task<Result<TenantResponse>> CriarTenantAsync(CriarTenantRequest r,CancellationToken ct){logger.LogInformation("Criando tenant seed {Slug}",r.Slug);return Ok(new TenantResponse(Guid.NewGuid(),r.Nome,r.Slug,"Ativo"));}
public Task<Result<IReadOnlyList<SetorResponse>>> SetoresAsync(CancellationToken ct)=>Ok<IReadOnlyList<SetorResponse>>([new(Guid.NewGuid(),"Diretoria Executiva","Estratégia e governança","Ativo"),new(Guid.NewGuid(),"Administrativo / Financeiro","Financeiro e faturamento","Ativo"),new(Guid.NewGuid(),"Marketing","Campanhas e branding","Ativo"),new(Guid.NewGuid(),"Vendas","CRM e pedidos","Ativo"),new(Guid.NewGuid(),"Logística","Estoque e expedição","Ativo")]);
public Task<Result<SetorResponse>> CriarSetorAsync(CriarSetorRequest r,CancellationToken ct)=>Ok(new SetorResponse(Guid.NewGuid(),r.Nome,r.Descricao,"Ativo"));
public Task<Result<IReadOnlyList<UsuarioResponse>>> UsuariosAsync(CancellationToken ct)=>Ok<IReadOnlyList<UsuarioResponse>>([new(Guid.NewGuid(),"Admin IntegraRP","admin@integrarp.local","Ativo")]);
public Task<Result<IReadOnlyList<ProcessoResponse>>> ProcessosAsync(CancellationToken ct)=>TemplatesAsync(ct);
public Task<Result<IReadOnlyList<ProcessoResponse>>> TemplatesAsync(CancellationToken ct)=>Ok<IReadOnlyList<ProcessoResponse>>([new(Guid.NewGuid(),"Emissão de Boletos","Administrativo / Financeiro","Template"),new(Guid.NewGuid(),"Separação de Pedidos","Logística","Template"),new(Guid.NewGuid(),"Roteirização","Entregas e Transporte","Template")]);
public Task<Result<IReadOnlyList<TarefaResponse>>> TarefasAsync(CancellationToken ct)=>Ok<IReadOnlyList<TarefaResponse>>([new(Guid.NewGuid(),"Validar pedido #1001","Aberta","Alta","Operações"),new(Guid.NewGuid(),"Emitir boleto cliente piloto","Em andamento","Média","Financeiro")]);
public Task<Result<TarefaResponse>> CriarTarefaAsync(CriarTarefaRequest r,CancellationToken ct)=>Ok(new TarefaResponse(Guid.NewGuid(),r.Titulo,"Aberta",r.Prioridade,"A definir"));
public Task<Result<TarefaResponse>> ConcluirTarefaAsync(Guid id,CancellationToken ct)=>Ok(new TarefaResponse(id,"Tarefa concluída","Concluída","Média","Operações"));
public Task<Result<IReadOnlyList<ProjectBoardResponse>>> BoardsAsync(CancellationToken ct)=>Ok<IReadOnlyList<ProjectBoardResponse>>([BoardSeed(Guid.Parse("22222222-2222-2222-2222-222222222222"))]);
public Task<Result<ProjectBoardResponse>> BoardAsync(Guid id,CancellationToken ct)=>Ok(BoardSeed(id));
public Task<Result<ProjectBoardResponse>> CriarBoardAsync(CriarProjectBoardRequest r,CancellationToken ct)=>Ok(BoardSeed(Guid.NewGuid()) with { Nome=r.Nome });
public Task<Result<ProjectItemResponse>> CriarItemAsync(CriarProjectItemRequest r,CancellationToken ct)=>Ok(new ProjectItemResponse(Guid.NewGuid(),r.Titulo,"Backlog",r.Prioridade));
public Task<Result<ProjectItemResponse>> MoverItemAsync(Guid id,MoverProjectItemRequest r,CancellationToken ct)=>Ok(new ProjectItemResponse(id,"Item movido","Movido","Média"));
public Task<Result<object>> ComentarItemAsync(Guid id,CriarComentarioRequest r,CancellationToken ct)=>Ok<object>(new{itemId=id,r.Mensagem});
public Task<Result<IReadOnlyList<CatalogoModuloResponse>>> ModulosAsync(CancellationToken ct)=>Ok<IReadOnlyList<CatalogoModuloResponse>>([new("crm","CRM/Vendas","bi-people","Ativo"),new("estoque","Produtos e Estoque","bi-box-seam","Ativo"),new("financeiro","Financeiro","bi-cash-coin","Ativo"),new("project","Project Central","bi-kanban","Ativo")]);
static ProjectBoardResponse BoardSeed(Guid id)=>new(id,"Implantação IntegraRP",[new(Guid.NewGuid(),"Backlog",[new ProjectItemResponse(Guid.NewGuid(),"Mapear processos base","Aberto","Alta")]),new(Guid.NewGuid(),"Em andamento",[]),new(Guid.NewGuid(),"Concluído",[])]);
static Task<Result<T>> Ok<T>(T v)=>Task.FromResult(Result<T>.Success(v));}
