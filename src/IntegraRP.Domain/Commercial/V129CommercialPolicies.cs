using System.Text.RegularExpressions;

namespace IntegraRP.Domain.Commercial;

public static partial class CustomerPolicy
{
    public static string NormalizeDocument(string? value) => new((value ?? string.Empty).Where(char.IsDigit).ToArray());
    public static string? Validate(string name, string? email, string? phone)
    {
        if (string.IsNullOrWhiteSpace(name)) return "Nome do cliente é obrigatório.";
        if (!string.IsNullOrWhiteSpace(email) && !EmailRegex().IsMatch(email)) return "E-mail inválido.";
        if (!string.IsNullOrWhiteSpace(phone) && NormalizeDocument(phone).Length < 8) return "Telefone inválido.";
        return null;
    }
    [GeneratedRegex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")]
    private static partial Regex EmailRegex();
}

public static class ProductPolicy
{
    public static string? ValidateCategory(string code, string name)
        => string.IsNullOrWhiteSpace(code) ? "Código da categoria é obrigatório." : string.IsNullOrWhiteSpace(name) ? "Nome da categoria é obrigatório." : null;
    public static string? ValidateProduct(string sku, string name, Guid categoryId, decimal price, decimal minimumStock)
    {
        if (string.IsNullOrWhiteSpace(sku)) return "SKU é obrigatório.";
        if (string.IsNullOrWhiteSpace(name)) return "Nome do produto é obrigatório.";
        if (categoryId == Guid.Empty) return "Categoria é obrigatória.";
        if (price < 0) return "Preço não pode ser negativo.";
        if (minimumStock < 0) return "Estoque mínimo não pode ser negativo.";
        return null;
    }
}

public static class InventoryPolicy
{
    public static string? ValidateMovement(Guid tenantId, Guid productId, decimal quantity, string locationCode, string reason, Guid userId, string idempotencyKey)
    {
        if (tenantId == Guid.Empty) return "Tenant é obrigatório.";
        if (productId == Guid.Empty) return "Produto é obrigatório.";
        if (quantity <= 0) return "Quantidade deve ser maior que zero.";
        if (string.IsNullOrWhiteSpace(locationCode)) return "Local é obrigatório.";
        if (string.IsNullOrWhiteSpace(reason)) return "Motivo é obrigatório.";
        if (userId == Guid.Empty) return "Usuário é obrigatório.";
        if (string.IsNullOrWhiteSpace(idempotencyKey)) return "Chave de idempotência é obrigatória.";
        return null;
    }
}

public static class OrderStateMachine
{
    public const string Draft = "rascunho";
    public const string Confirmed = "confirmado";
    public const string Picking = "em_separacao";
    public const string Picked = "separado";
    public const string BillingPending = "faturamento_pendente";
    public const string Cancelled = "cancelado";
    public static bool CanAddItem(string status) => status == Draft;
    public static bool CanConfirm(string status) => status is Draft or Confirmed;
    public static bool CanCancel(string status) => status is Draft or Confirmed or Picking;
}

public static class TaskStateMachine
{
    public const string Open = "aberta";
    public const string Assigned = "assumida";
    public const string InProgress = "em_execucao";
    public const string Done = "concluida";
    public const string Cancelled = "cancelada";
    public static bool CanTransition(string from, string to) => (from, to) is (Open, Assigned) or (Assigned, InProgress) or (InProgress, Done) or (Open, Cancelled) or (Assigned, Cancelled) or (InProgress, Cancelled);
}

public sealed record StockReservation(Guid ProductId, decimal Quantity, string LocationCode)
{
    public decimal Reserve(decimal physical, decimal reserved)
    {
        if (Quantity <= 0) throw new InvalidOperationException("Quantidade da reserva deve ser positiva.");
        if (physical - reserved < Quantity) throw new InvalidOperationException("Saldo disponível insuficiente.");
        return reserved + Quantity;
    }
}
