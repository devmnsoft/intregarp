@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File %~dp0db-apply-migrations.ps1 %*
