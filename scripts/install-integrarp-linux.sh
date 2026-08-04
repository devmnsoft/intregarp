#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST=localhost PORT=5432 DATABASE=integrarp ADMIN_DATABASE=postgres USERNAME=postgres PASSWORD= INSTALL_MODE=Development RESET_DATABASE=false SEED_DEMO=false
while (($#)); do case "$1" in
 --host) HOST="$2"; shift 2;; --port) PORT="$2"; shift 2;; --database) DATABASE="$2"; shift 2;; --admin-database) ADMIN_DATABASE="$2"; shift 2;; --username) USERNAME="$2"; shift 2;; --password) PASSWORD="$2"; shift 2;; --install-mode) INSTALL_MODE="$2"; shift 2;; --reset-database) RESET_DATABASE=true; shift;; --seed-demo) SEED_DEMO=true; shift;; *) echo "Parâmetro desconhecido: $1" >&2; exit 2;; esac; done
command -v psql >/dev/null || { echo 'psql não encontrado.' >&2; exit 127; }
[[ "$DATABASE" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || { echo 'Nome de banco inválido.' >&2; exit 2; }
if [[ "$INSTALL_MODE" == Production ]]; then
 : "${INTEGRARP_BOOTSTRAP_ADMIN_EMAIL:?obrigatório em Production}"; : "${INTEGRARP_BOOTSTRAP_ADMIN_PASSWORD:?obrigatório em Production}"; : "${INTEGRARP_BOOTSTRAP_ADMIN_NAME:?obrigatório em Production}"
fi
export PGPASSWORD="$PASSWORD" PGOPTIONS="-c integrarp.install_mode=$INSTALL_MODE -c integrarp.seed_demo=$SEED_DEMO"
admin=(psql -X -h "$HOST" -p "$PORT" -U "$USERNAME" -d "$ADMIN_DATABASE" --set ON_ERROR_STOP=1)
"${admin[@]}" -c 'SELECT 1' >/dev/null
exists="$("${admin[@]}" -Atc "SELECT 1 FROM pg_database WHERE datname='$DATABASE'")"
if [[ "$RESET_DATABASE" == true && "$exists" == 1 ]]; then "${admin[@]}" -c "DROP DATABASE \"$DATABASE\" WITH (FORCE)"; exists=; fi
if [[ "$exists" != 1 ]]; then "${admin[@]}" -c "CREATE DATABASE \"$DATABASE\""; fi
target=(psql -X -h "$HOST" -p "$PORT" -U "$USERNAME" -d "$DATABASE" --set ON_ERROR_STOP=1)
"${target[@]}" --file "$ROOT/database/scriptcompleto.sql"
"${target[@]}" --file "$ROOT/database/validate_scriptcompleto.sql"
echo "IntegraRP v1.60.2 instalado em $HOST:$PORT/$DATABASE (modo $INSTALL_MODE)."
if [[ "$INSTALL_MODE" != Production ]]; then echo 'URL: http://localhost:5000 | usuário: admin@integrarp.local | troca de senha obrigatória'; fi
