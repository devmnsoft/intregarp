namespace IntegraRP.Domain.Operations;

public enum DeliveryRouteStatus { Planejada, EmRota, Concluida, Cancelada, ComOcorrencia }
public enum DeliveryStopStatus { Pendente, EmAtendimento, Entregue, NaoEntregue, Reagendada, ComOcorrencia }
public enum DeliveryManifestStatus { Rascunho, Conferido, EmRota, Finalizado, Cancelado }
public enum ProofOfDeliveryStatus { Registrada }
public enum DeliveryOccurrenceType { ClienteAusente, EnderecoIncorreto, MercadoriaAvariada, RecusaRecebimento, Atraso, Devolucao, Outro }
public enum DeliveryOccurrenceStatus { Aberta, EmTratamento, Resolvida, Cancelada }

public sealed record RouteCode
{
    public RouteCode(string value)
    {
        Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Código da rota obrigatório.") : value.Trim();
    }

    public string Value { get; }
}
public sealed record ManifestCode
{
    public ManifestCode(string value)
    {
        Value = string.IsNullOrWhiteSpace(value) ? throw new ArgumentException("Código do romaneio obrigatório.") : value.Trim();
    }

    public string Value { get; }
}
public sealed record GeoCoordinate(decimal Latitude, decimal Longitude);
public sealed record DeliverySequence(decimal Value);
public sealed record VolumeCount
{
    public VolumeCount(int value)
    {
        Value = value < 0 ? throw new ArgumentOutOfRangeException(nameof(value)) : value;
    }

    public int Value { get; }
}

public sealed record DeliveryRoute(Guid Id, Guid TenantId, RouteCode Codigo, string Nome, DateOnly DataRota, Guid? MotoristaUsuarioId, string? VeiculoDescricao, DeliveryRouteStatus Status, int TotalParadas, int ParadasConcluidas, decimal? DistanciaEstimativaKm);
public sealed record DeliveryRouteStop(Guid Id, Guid TenantId, Guid RouteId, Guid? PedidoId, Guid? ClienteId, string? EnderecoTexto, GeoCoordinate? Coordenada, DeliverySequence Ordem, DeliveryStopStatus Status, string? Observacao);
public sealed record DeliveryManifest(Guid Id, Guid TenantId, ManifestCode Codigo, DateOnly DataRomaneio, Guid? RotaId, Guid? MotoristaUsuarioId, DeliveryManifestStatus Status, int TotalPedidos, int TotalVolumes);
public sealed record DeliveryManifestItem(Guid Id, Guid TenantId, Guid ManifestId, Guid? PedidoId, Guid? ClienteId, VolumeCount QuantidadeVolumes, string Status, DeliverySequence Ordem);
public sealed record DeliveryMonitoring(Guid TenantId, int Pendentes, int EmRota, int Concluidas, int OcorrenciasAbertas, decimal SlaPercentual);
public sealed record ProofOfDelivery(Guid Id, Guid TenantId, Guid? PedidoId, Guid? RotaId, Guid? RotaParadaId, Guid? RomaneioId, string? RecebedorNome, ProofOfDeliveryStatus Status, DateTimeOffset EntregueEm);
public sealed record DeliveryOccurrence(Guid Id, Guid TenantId, Guid? PedidoId, Guid? RotaId, Guid? RotaParadaId, DeliveryOccurrenceType Tipo, DeliveryOccurrenceStatus Status, string Descricao, Guid? ResponsavelUsuarioId);
