namespace IntegraRP.Domain.Mobile;

public enum MobilePlatform { Android, Ios, Web }
public enum MobileNotificationStatus { Pendente, Lida, Enviada, Erro }
public enum MobileEvidenceType { Foto, Arquivo, Assinatura, Gps, Comentario, Pod }
public enum MobileTaskExecutionStatus { EmExecucao, Concluida, Cancelada, ErroSync }
public enum MobileApprovalDecision { Aprovado, Reprovado }
public enum MobileSyncStatus { Pendente, Processando, Processado, Erro }
public sealed record DeviceId(string Value);
public sealed record GeoCoordinate(decimal Latitude, decimal Longitude, decimal? AccuracyMeters);
public sealed record SignatureData(string NomeAssinante, string? Documento, string? Svg);
public abstract record MobileEntity(Guid Id, Guid TenantId, DateTimeOffset CriadoEm);
public sealed record MobileDevice(Guid Id, Guid TenantId, Guid UsuarioId, DeviceId DeviceId, MobilePlatform Plataforma, string Status, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
public sealed record MobileSession(Guid Id, Guid TenantId, Guid UsuarioId, Guid MobileDispositivoId, DateTimeOffset ExpiraEm, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
public sealed record MobileNotification(Guid Id, Guid TenantId, Guid UsuarioId, string Titulo, string Mensagem, MobileNotificationStatus Status, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
public sealed record MobileAttachment(Guid Id, Guid TenantId, string StorageKey, string? ContentType, long? TamanhoBytes, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
public sealed record MobileEvidence(Guid Id, Guid TenantId, MobileEvidenceType Tipo, Guid? TarefaId, Guid? ProcessoInstanciaId, Guid? PedidoId, Guid? ExecucaoId, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm) { public bool HasLink => TarefaId.HasValue || ProcessoInstanciaId.HasValue || PedidoId.HasValue || ExecucaoId.HasValue; }
public sealed record MobileSignature(Guid Id, Guid TenantId, SignatureData Dados, Guid? TarefaId, Guid? PedidoId, Guid? ProcessoInstanciaId, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
public sealed record MobileGeoEvent(Guid Id, Guid TenantId, Guid UsuarioId, GeoCoordinate Coordenada, string Origem, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
public sealed record MobileSyncQueueItem(Guid Id, Guid TenantId, string Tipo, string PayloadJson, MobileSyncStatus Status, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
public sealed record MobileTaskExecution(Guid Id, Guid TenantId, Guid TarefaId, Guid UsuarioId, MobileTaskExecutionStatus Status, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm) { public bool CanComplete => Status == MobileTaskExecutionStatus.EmExecucao; }
public sealed record MobileApproval(Guid Id, Guid TenantId, Guid TarefaId, Guid UsuarioId, MobileApprovalDecision Decisao, string? Comentario, DateTimeOffset CriadoEm) : MobileEntity(Id, TenantId, CriadoEm);
