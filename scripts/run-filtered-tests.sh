#!/usr/bin/env bash
set -euo pipefail

if (($# != 2)); then
  echo "Uso: $0 <filtro> <nome-do-resultado>" >&2
  exit 64
fi

filter="$1"
result_name="$2"
project="tests/IntegraRP.Tests/IntegraRP.Tests.csproj"
results="${TEST_RESULTS_DIR:-artifacts/test-results}"
mkdir -p "$results"

list_file="$results/${result_name}-discovered.txt"
dotnet test "$project" --configuration Release --no-restore \
  --list-tests --filter "$filter" | tee "$list_file"

# A saída estável do VSTest indenta cada nome de teste encontrado.
test_count="$(sed -n '/The following Tests are available:/,$p' "$list_file" | sed '1d' | grep -cE '^[[:space:]]+[^[:space:]]' || true)"
echo "Testes encontrados para '$filter': $test_count"
if ((test_count == 0)); then
  echo "ERRO: o filtro não encontrou testes; o job não pode passar sem executar testes." >&2
  exit 3
fi

dotnet test "$project" --configuration Release --no-restore \
  --filter "$filter" \
  --logger "trx;LogFileName=${result_name}.trx" \
  --results-directory "$results"
