@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0migrate-windows.ps1" %*
