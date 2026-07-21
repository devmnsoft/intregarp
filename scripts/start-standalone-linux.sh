#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; mkdir -p "$ROOT/logs" "$ROOT/.pids"
ASPNETCORE_URLS=http://localhost:7001 dotnet run --project "$ROOT/src/IntegraRP.Api" >"$ROOT/logs/api.log" 2>&1 & echo $! > "$ROOT/.pids/api.pid"
ASPNETCORE_URLS=http://localhost:5001 dotnet run --project "$ROOT/src/IntegraRP.Web" >"$ROOT/logs/web.log" 2>&1 & echo $! > "$ROOT/.pids/web.pid"
dotnet run --project "$ROOT/src/IntegraRP.Worker" >"$ROOT/logs/worker.log" 2>&1 & echo $! > "$ROOT/.pids/worker.pid"
