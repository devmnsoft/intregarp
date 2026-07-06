using IntegraRP.Application.Common;
using Microsoft.Extensions.Logging;

namespace IntegraRP.Application.V12;

public sealed record V12Request(Guid TenantId, Guid? Id = null, string? Payload = null);
public sealed record V12Response(Guid Id, Guid TenantId, string Status, string Message);

public interface IIntegrationConnectorRepository { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IIntegrationExecutionRepository { Task<Result<IReadOnlyList<V12Response>>> ListAsync(Guid tenantId, CancellationToken cancellationToken); }
public interface IWebhookIntegrationService { Task<Result<V12Response>> RegisterAsync(string code, V12Request request, CancellationToken cancellationToken); }
public interface IIntegrationQueueService { Task<Result<V12Response>> ProcessAsync(Guid tenantId, CancellationToken cancellationToken); }
public interface IIntegrationCredentialResolver { Task<Result<string>> ResolveReferenceAsync(Guid tenantId, string secretReference, CancellationToken cancellationToken); }
public interface IFiscalDocumentRepository { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IFiscalProvider { Task<Result<V12Response>> EmitAsync(V12Request request, CancellationToken cancellationToken); }
public interface IFiscalEmissionService { Task<Result<V12Response>> EmitFakeAsync(V12Request request, CancellationToken cancellationToken); }
public interface IFiscalValidationService { Task<Result<V12Response>> ValidateAsync(V12Request request, CancellationToken cancellationToken); }
public interface IFiscalDocumentRenderer { Task<Result<string>> RenderDanfeHtmlAsync(Guid tenantId, Guid documentId, CancellationToken cancellationToken); }
public interface IFiscalAuditService { Task<Result<V12Response>> AuditAsync(V12Request request, CancellationToken cancellationToken); }
public interface IBankAccountRepository { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IBankStatementRepository { Task<Result<IReadOnlyList<V12Response>>> ListEntriesAsync(Guid tenantId, Guid importId, CancellationToken cancellationToken); }
public interface IBankStatementImporter { Task<Result<IReadOnlyList<V12Response>>> ImportAsync(V12Request request, CancellationToken cancellationToken); }
public interface IReconciliationRepository { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IBankReconciliationService { Task<Result<V12Response>> SuggestAsync(V12Request request, CancellationToken cancellationToken); }
public interface IOpenFinanceProvider { Task<Result<V12Response>> SandboxAsync(V12Request request, CancellationToken cancellationToken); }
public interface IReceivableProjectionService { Task<Result<IReadOnlyList<V12Response>>> GenerateAsync(Guid tenantId, CancellationToken cancellationToken); }
public interface IDelinquencyAlertService { Task<Result<IReadOnlyList<V12Response>>> GenerateAsync(Guid tenantId, CancellationToken cancellationToken); }
public interface IRouteOptimizationRepository { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IRouteOptimizationService { Task<Result<IReadOnlyList<V12Stop>>> OptimizeAsync(Guid tenantId, IReadOnlyList<V12Stop> stops, CancellationToken cancellationToken); }
public interface IDistanceCalculator { double HaversineKm(double lat1, double lon1, double lat2, double lon2); }
public interface IRouteProvider { Task<Result<V12Response>> SandboxAsync(V12Request request, CancellationToken cancellationToken); }
public interface IGeocodingProvider { Task<Result<V12Response>> SandboxAsync(V12Request request, CancellationToken cancellationToken); }
public interface IDistanceMatrixProvider { Task<Result<V12Response>> SandboxAsync(V12Request request, CancellationToken cancellationToken); }
public interface IOfflineDeviceRepository { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IOfflineSyncRepository { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IOfflinePackageService { Task<Result<V12Response>> CreateAsync(V12Request request, CancellationToken cancellationToken); }
public interface IOfflineConflictDetector { Task<Result<IReadOnlyList<V12Response>>> DetectAsync(Guid tenantId, CancellationToken cancellationToken); }
public interface IOfflineConflictResolver { Task<Result<V12Response>> ResolveAsync(V12Request request, CancellationToken cancellationToken); }
public interface IOfflineCheckpointService { Task<Result<V12Response>> SaveAsync(V12Request request, CancellationToken cancellationToken); }

public sealed record V12Stop(Guid Id, double Latitude, double Longitude, int Priority = 0, DateTimeOffset? WindowStart = null);
public sealed class HaversineDistanceCalculator : IDistanceCalculator { public double HaversineKm(double lat1,double lon1,double lat2,double lon2){ const double r=6371d; double dLat=(lat2-lat1)*Math.PI/180d,dLon=(lon2-lon1)*Math.PI/180d; double a=Math.Sin(dLat/2)*Math.Sin(dLat/2)+Math.Cos(lat1*Math.PI/180d)*Math.Cos(lat2*Math.PI/180d)*Math.Sin(dLon/2)*Math.Sin(dLon/2); return 2*r*Math.Asin(Math.Sqrt(a)); } }
public sealed class SimpleRouteOptimizationService(IDistanceCalculator distance, ILogger<SimpleRouteOptimizationService> logger) : IRouteOptimizationService { public Task<Result<IReadOnlyList<V12Stop>>> OptimizeAsync(Guid tenantId,IReadOnlyList<V12Stop> stops,CancellationToken cancellationToken){ try { if(tenantId==Guid.Empty) return Task.FromResult(Result<IReadOnlyList<V12Stop>>.Failure("Tenant inválido.")); var ordered=stops.OrderByDescending(s=>s.Priority).ThenBy(s=>s.WindowStart ?? DateTimeOffset.MaxValue).ThenBy(s=>distance.HaversineKm(stops[0].Latitude,stops[0].Longitude,s.Latitude,s.Longitude)).ToList(); logger.LogInformation("Rota otimizada para tenant {TenantId}", tenantId); return Task.FromResult(Result<IReadOnlyList<V12Stop>>.Success(ordered)); } catch(Exception ex){ logger.LogError(ex,"Erro ao otimizar rota"); return Task.FromResult(Result<IReadOnlyList<V12Stop>>.Failure(ex.Message)); } } }
public sealed class FakeFiscalProvider(ILogger<FakeFiscalProvider> logger) : IFiscalProvider { public Task<Result<V12Response>> EmitAsync(V12Request request,CancellationToken cancellationToken){ try{ if(request.TenantId==Guid.Empty) return Task.FromResult(Result<V12Response>.Failure("Tenant inválido.")); logger.LogInformation("Emissão fiscal fake sem SEFAZ real para {TenantId}", request.TenantId); return Task.FromResult(Result<V12Response>.Success(new V12Response(request.Id ?? Guid.NewGuid(),request.TenantId,"emitida_fake","XML fake e DANFE HTML fake gerados."))); } catch(Exception ex){ return Task.FromResult(Result<V12Response>.Failure(ex.Message)); } } }
public sealed class SandboxFiscalProvider(ILogger<SandboxFiscalProvider> logger) : IFiscalProvider { public Task<Result<V12Response>> EmitAsync(V12Request request,CancellationToken cancellationToken){ logger.LogInformation("Sandbox fiscal estruturado sem chamada externa real."); return Task.FromResult(Result<V12Response>.Success(new V12Response(request.Id ?? Guid.NewGuid(),request.TenantId,"autorizada_sandbox","Sandbox local."))); } }
