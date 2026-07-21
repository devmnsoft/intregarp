using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.DataProtection;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews(options => options.Filters.Add(new Microsoft.AspNetCore.Mvc.AutoValidateAntiforgeryTokenAttribute()));
builder.Services.AddDataProtection().SetApplicationName("IntegraRP.Web");
builder.Services.AddAntiforgery(options => { options.Cookie.Name = "__Host-IntegraRP.AntiForgery"; options.Cookie.HttpOnly = true; options.Cookie.SameSite = SameSiteMode.Strict; options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest; });
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(options => { options.LoginPath = "/account/login"; options.AccessDeniedPath = "/account/access-denied"; options.ExpireTimeSpan = TimeSpan.FromHours(8); options.SlidingExpiration = true; options.Cookie.Name = "__Host-IntegraRP.Web"; options.Cookie.HttpOnly = true; options.Cookie.SameSite = SameSiteMode.Lax; options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest; });
builder.Services.AddAuthorization();
builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient("IntegraRP.Api", client => { client.BaseAddress = new Uri(builder.Configuration["IntegraRP:ApiBaseUrl"] ?? "http://localhost:7001"); });

var app = builder.Build();

if (!app.Environment.IsDevelopment()) app.UseExceptionHandler("/Home/Error");
app.UseStatusCodePagesWithReExecute("/account/session-expired", "?statusCode={0}");
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllerRoute("default", "{controller=Home}/{action=Dashboard}/{id?}");
app.Run();
