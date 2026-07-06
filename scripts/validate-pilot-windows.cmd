@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0validate-pilot-windows.ps1"
exit /b %ERRORLEVEL%
