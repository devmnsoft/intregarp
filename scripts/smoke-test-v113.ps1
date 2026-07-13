param(
    [string]$BaseUrl = "http://localhost:5000",
    [string]$Token = $env:INTEGRARP_TOKEN
)

$ErrorActionPreference = "Stop"
$headers = @{}
if ($Token) { $headers["Authorization"] = "Bearer $Token" }

function Invoke-Check($Name, $Method, $Path) {
    Write-Host "[v1.13] $Name -> $Method $Path"
    $response = Invoke-WebRequest -Method $Method -Uri "$BaseUrl$Path" -Headers $headers -ContentType "application/json"
    if ($response.StatusCode -ge 500) { throw "$Name retornou HTTP $($response.StatusCode)" }
    return $response
}

Invoke-Check "Dashboard" GET "/api/dashboard?profile=gestor" | Out-Null
Invoke-Check "Clientes" GET "/api/customers" | Out-Null
Invoke-Check "Produtos" GET "/api/products" | Out-Null
Invoke-Check "Estoque crítico" GET "/api/inventory/critical" | Out-Null
Invoke-Check "Pedidos" GET "/api/orders" | Out-Null
Invoke-Check "Tarefas" GET "/api/tasks/my" | Out-Null
Invoke-Check "Outbox" GET "/api/outbox" | Out-Null
Invoke-Check "Homologação" GET "/api/homologation/status" | Out-Null
Invoke-Check "Demo" GET "/api/demo/status" | Out-Null
Write-Host "Smoke v1.13 concluído."
