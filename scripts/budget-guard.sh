#!/usr/bin/env bash
# Gentle nudge, never an edit. If the continuation files in the current folder are bloated, print a
# reminder to run close-round. Silent when within budget. No LLM required.
#
# Wire it as a Claude Code Stop hook, a git pre-commit hook, or a manual/CI check. Exit code is 0
# either way (it never blocks); it just emits a reminder when over threshold.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$here/abp.conf.sh"

# Only speak inside a folder that actually has a progress file.
[[ -f "$ABP_PROGRESS_FILE" ]] || exit 0

approx_tokens() { echo $(( $(wc -w < "$1" | tr -d ' ') * 13 / 10 )); }

over=""
for f in "$ABP_PROGRESS_FILE" "$ABP_TODO_FILE"; do
  [[ -f "$f" ]] || continue
  tok=$(approx_tokens "$f")
  (( tok > ABP_GUARD_THRESHOLD )) && over+=" ${f}(~${tok}tok)"
done

[[ -z "$over" ]] && exit 0

# Claude Code Stop hooks surface JSON {"systemMessage": …}. For a git hook / CLI, the plain text on
# stderr is just as readable. We print both-friendly text.
msg="Continuation files over budget:${over}. When this round is verified, run close-round to prune them."
if [[ "${ABP_EMIT_JSON:-0}" == "1" ]]; then
  printf '{"systemMessage": "%s"}\n' "$msg"
else
  echo "[budget-guard] $msg" >&2
fi
exit 0
