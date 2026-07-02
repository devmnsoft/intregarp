namespace IntegraRP.Contracts.Requests;
public sealed record CriarTenantRequest(string Nome,string Slug);
public sealed record CriarSetorRequest(string Nome,string Descricao);
public sealed record CriarTarefaRequest(string Titulo,string Prioridade,Guid? ResponsavelUsuarioId);
public sealed record CriarProjectBoardRequest(string Nome);
public sealed record CriarProjectItemRequest(Guid BoardId,string Titulo,string Prioridade);
public sealed record MoverProjectItemRequest(Guid ColunaId);
public sealed record CriarComentarioRequest(string Mensagem);
