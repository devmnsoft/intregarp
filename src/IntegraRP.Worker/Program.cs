using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using IntegraRP.Infrastructure.DependencyInjection;
using IntegraRP.Worker;

var builder = Host.CreateApplicationBuilder(args);
builder.Services.AddInfrastructure(builder.Configuration);
builder.Services.AddHostedService<Worker>();
builder.Services.AddHostedService<MobileAiWorker>();
var host = builder.Build();
host.Run();
