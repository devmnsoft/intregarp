@echo off
setlocal
set BASE_URL=%1
if "%BASE_URL%"=="" set BASE_URL=http://localhost:5000
powershell -ExecutionPolicy Bypass -File "%~dp0smoke-test-v113.ps1" -BaseUrl "%BASE_URL%"
