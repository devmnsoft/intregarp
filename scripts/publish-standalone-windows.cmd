@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0publish-standalone-windows.ps1" %*
