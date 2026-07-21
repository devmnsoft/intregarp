using System.ComponentModel.DataAnnotations;

namespace IntegraRP.Web.ViewModels.Account;

public sealed class LoginViewModel
{
    [Required(ErrorMessage = "Informe a organização.")]
    [Display(Name = "Organização")]
    public string Tenant { get; set; } = string.Empty;

    [Required(ErrorMessage = "Informe o e-mail.")]
    [EmailAddress(ErrorMessage = "Informe um e-mail válido.")]
    [Display(Name = "E-mail")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Informe a senha.")]
    [DataType(DataType.Password)]
    [Display(Name = "Senha")]
    public string Password { get; set; } = string.Empty;

    [Display(Name = "Lembrar organização")]
    public bool RememberTenant { get; set; }

    public string? ReturnUrl { get; set; }
}
