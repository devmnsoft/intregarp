using IntegraRP.Contracts.Onboarding;

namespace IntegraRP.Web.ViewModels.Onboarding;

public sealed record OnboardingStepViewModel(int Number, string Title, string Description, string Route, string Estimate, bool Completed, bool Blocked)
{
    public string Status => Completed ? "Concluída" : Blocked ? "Bloqueada" : "Pendente";
}

public sealed record OnboardingPageViewModel(int Percentage, long RowVersion, bool Dismissed, bool Completed, DateTimeOffset LastInteractionAt, IReadOnlyList<OnboardingStepViewModel> Steps)
{
    public static OnboardingPageViewModel From(OnboardingStateDto state)
    {
        var definitions = new[] {
            ("Organização", "Confirme os dados da organização.", "/onboarding/company", "2 min"),
            ("Setores", "Revise quem executa cada atividade.", "/onboarding/sectors", "3 min"),
            ("Cliente", "Cadastre o primeiro cliente ativo.", "/onboarding/first-customer", "3 min"),
            ("Categoria", "Organize seu catálogo.", "/onboarding/first-category", "2 min"),
            ("Produto", "Cadastre um produto para vender.", "/onboarding/first-product", "3 min"),
            ("Estoque", "Registre saldo físico em um local.", "/onboarding/first-inventory", "3 min"),
            ("Pedido", "Crie e confirme o primeiro pedido.", "/onboarding/first-order", "5 min"),
            ("Separação", "Conclua a tarefa com checklist e evidência.", "/onboarding/first-task", "5 min") };
        var completed = state.CompletedSteps.ToHashSet();
        var steps = definitions.Select((item, index) => new OnboardingStepViewModel(index + 1, item.Item1, item.Item2, item.Item3, item.Item4, completed.Contains(index + 1), index + 1 > state.CurrentStep && !completed.Contains(index + 1))).ToArray();
        return new(state.Percentage, state.RowVersion, state.Dismissed, state.Completed, state.LastInteractionAt, steps);
    }
}
