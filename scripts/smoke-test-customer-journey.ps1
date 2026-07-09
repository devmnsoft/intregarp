param([string]$ApiBaseUrl="http://localhost:8080")
$ErrorActionPreference="Stop"
$checks=@('/api/health','/swagger','/api/validation/demo/status','/api/validation/flow/order-to-billing-demo','/api/validation/flow/customer-full-journey','/api/validation/scriptcompleto/status')
foreach($c in $checks){ Invoke-WebRequest "$ApiBaseUrl$c" -UseBasicParsing | Out-Null }
Write-Host "Smoke da jornada do cliente concluído."
