@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0db-debug-scriptcompleto.ps1" %*
exit /b %ERRORLEVEL%
