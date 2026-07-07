param([string]$ApiUrl='http://localhost:5000')
$ErrorActionPreference='Stop'
Invoke-RestMethod "$ApiUrl/api/validation/flow/customer-full-journey"
Invoke-RestMethod "$ApiUrl/api/validation/flow/order-to-billing-demo"
