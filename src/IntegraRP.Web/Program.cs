var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();
builder.Services.AddHttpClient("IntegraRP.Api", client =>
{
    client.BaseAddress = new Uri(builder.Configuration["IntegraRP:ApiBaseUrl"] ?? "http://localhost:7001");
});

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
}

app.UseStaticFiles();
app.UseRouting();
app.MapControllerRoute("default", "{controller=Home}/{action=Dashboard}/{id?}");
app.Run();
