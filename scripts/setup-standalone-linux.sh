#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; : "${DATABASE_URL:=postgresql://integrarp@localhost:5432/integrarp}"
dotnet --info >/dev/null
psql --version >/dev/null
psql -X "$DATABASE_URL" --set ON_ERROR_STOP=1 --file "$ROOT/database/scriptcompleto.sql"
psql -X "$DATABASE_URL" --set ON_ERROR_STOP=1 --file "$ROOT/database/validate_scriptcompleto.sql"
dotnet restore "$ROOT/IntegraRP.sln"; dotnet build "$ROOT/IntegraRP.sln" --no-restore
mkdir -p "$ROOT/storage" "$ROOT/logs" "$ROOT/artifacts/v119/database"
