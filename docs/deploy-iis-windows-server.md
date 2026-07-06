# Deploy em Windows Server/IIS

## Pré-requisitos
- Windows Server atualizado.
- IIS com ASP.NET Core Hosting Bundle do .NET 8 instalado.
- PostgreSQL acessível pela API e pelo Worker.
- Pacotes publicados da API, Web e Worker.

## Publicação
1. Executar `dotnet publish src/IntegraRP.Api/IntegraRP.Api.csproj -c Release -o C:\IntegraRP\Api`.
2. Executar `dotnet publish src/IntegraRP.Web/IntegraRP.Web.csproj -c Release -o C:\IntegraRP\Web`.
3. Executar `dotnet publish src/IntegraRP.Worker/IntegraRP.Worker.csproj -c Release -o C:\IntegraRP\Worker`.

## IIS
- Criar Application Pool sem código gerenciado para API e Web.
- Configurar portas distintas ou reverse proxy.
- Definir `ASPNETCORE_ENVIRONMENT=Production`.
- Definir `ConnectionStrings__IntegraRP` na API e no Worker.
- Definir `IntegraRP__ApiBaseUrl` na Web.
- Garantir permissão de leitura/escrita em pastas de logs.

## Validação
- Swagger: `https://servidor-api/swagger`.
- Health: `https://servidor-api/api/health/live` e `/api/health/ready`.
- Web: abrir URL pública e validar login demo.

## Troubleshooting
- 500.19: revisar Hosting Bundle, `web.config`, permissões e Application Pool.
- Permissão: conceder acesso ao usuário do pool nas pastas publicadas.
- Banco: validar firewall, DNS, porta 5432, usuário e senha.

## Rollback
Parar Application Pools, restaurar pasta da versão anterior, restaurar banco se necessário e validar health checks antes de liberar usuários.
