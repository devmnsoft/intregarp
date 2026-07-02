$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
Start-Process powershell -ArgumentList '-NoExit','-File', (Join-Path $PSScriptRoot 'run-api-windows.ps1')
Start-Process powershell -ArgumentList '-NoExit','-File', (Join-Path $PSScriptRoot 'run-web-windows.ps1')
Start-Process powershell -ArgumentList '-NoExit','-File', (Join-Path $PSScriptRoot 'run-worker-windows.ps1')
