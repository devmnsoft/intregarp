using Microsoft.AspNetCore.Razor.TagHelpers;

namespace IntegraRP.Web.TagHelpers;

[HtmlTargetElement("app-icon")]
public sealed class AppIconTagHelper : TagHelper
{
    [HtmlAttributeName("name")] public required string Name { get; set; }
    [HtmlAttributeName("size")] public int Size { get; set; } = 20;
    [HtmlAttributeName("label")] public string? Label { get; set; }
    [HtmlAttributeName("decorative")] public bool Decorative { get; set; } = true;
    [HtmlAttributeName("class")] public string? CssClass { get; set; }
    [HtmlAttributeName("title")] public string? Title { get; set; }

    public override void Process(TagHelperContext context, TagHelperOutput output)
    {
        if (!IntegraRpIconCatalog.Names.Contains(Name)) throw new InvalidOperationException($"Ícone semântico desconhecido: {Name}.");
        if (!Decorative && string.IsNullOrWhiteSpace(Label) && string.IsNullOrWhiteSpace(Title))
            throw new InvalidOperationException($"O ícone de ação '{Name}' exige label ou title acessível.");
        output.TagName = "svg";
        output.Attributes.SetAttribute("class", $"app-icon {CssClass}".Trim());
        output.Attributes.SetAttribute("width", Size);
        output.Attributes.SetAttribute("height", Size);
        output.Attributes.SetAttribute("focusable", "false");
        if (Decorative) output.Attributes.SetAttribute("aria-hidden", "true");
        else { output.Attributes.SetAttribute("role", "img"); output.Attributes.SetAttribute("aria-label", Label ?? Title); }
        var title = string.IsNullOrWhiteSpace(Title) || Decorative ? string.Empty : $"<title>{System.Net.WebUtility.HtmlEncode(Title)}</title>";
        output.Content.SetHtmlContent($"{title}<use href=\"/icons/integrarp-icons.svg#icon-{Name}\"></use>");
    }
}
