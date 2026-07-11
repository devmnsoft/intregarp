param([string]$BaseUrl = "http://localhost:5000")
$ErrorActionPreference = "Stop"
function Invoke-Step($Name, $Method, $Path, $Body = $null) {
  Write-Host "==> $Name $Method $Path"
  $uri = "$BaseUrl$Path"
  if ($Body -eq $null) { Invoke-RestMethod -Method $Method -Uri $uri }
  else { Invoke-RestMethod -Method $Method -Uri $uri -ContentType "application/json" -Body ($Body | ConvertTo-Json -Depth 10) }
}
Invoke-Step "API health" GET "/api/health"
Invoke-Step "Dashboard" GET "/api/dashboard"
Invoke-Step "Jornada" GET "/api/journey/what-to-do-now"
Invoke-Step "Demo run-all" POST "/api/demo/run-all"
Invoke-Step "Homologação" GET "/api/homologation/status"
Invoke-Step "Worker" GET "/api/validation/worker/status"
Write-Host "Smoke v1.12 finalizado; execute o fluxo CRUD autenticado conforme documentação para criar cliente, produto, estoque, pedido, tarefa, fatura, título, boleto e outbox."
