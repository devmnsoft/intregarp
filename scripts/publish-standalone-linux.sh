#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
case "$(basename "$0")" in
stop*) for f in "$ROOT"/.pids/*.pid; do [ -f "$f" ] && kill "$(cat "$f")" 2>/dev/null || true; done ;;
status*) for f in "$ROOT"/.pids/*.pid; do [ -f "$f" ] && ps -p "$(cat "$f")"; done ;;
test*) dotnet test "$ROOT/IntegraRP.sln" ;;
publish*) dotnet publish "$ROOT/IntegraRP.sln" -c Release -o "$ROOT/artifacts/v119/publish" ;;
esac
