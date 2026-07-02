@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run-worker-windows.ps1" %*
