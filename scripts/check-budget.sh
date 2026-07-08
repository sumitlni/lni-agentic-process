#!/usr/bin/env bash
# Report approximate token sizes of the continuation files in the current folder.
# Tokens ≈ words × 1.3. No LLM required. Usage: run from a folder that has the continuation files.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$here/abp.conf.sh"

approx_tokens() { echo $(( $(wc -w < "$1" | tr -d ' ') * 13 / 10 )); }

report() {
  local f="$1" budget="$2"
  if [[ ! -f "$f" ]]; then printf "  %-16s (not found)\n" "$f"; return; fi
  local tok flag=""; tok=$(approx_tokens "$f")
  (( tok > budget )) && flag="  <-- OVER ${budget} (prune via close-round)"
  printf "  %-16s ~%6s tok%s\n" "$f" "$tok" "$flag"
}

echo "continuation-file sizes (current folder):"
report "$ABP_PROGRESS_FILE" "$ABP_BUDGET_PROGRESS"
report "$ABP_TODO_FILE"     "$ABP_BUDGET_TODO"
echo "targets: ${ABP_PROGRESS_FILE} <= ${ABP_BUDGET_PROGRESS} tok, ${ABP_TODO_FILE} <= ${ABP_BUDGET_TODO} tok"
