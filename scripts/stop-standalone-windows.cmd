@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop-standalone-windows.ps1" %*
