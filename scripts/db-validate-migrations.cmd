@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File %~dp0db-validate-migrations.ps1 %*
