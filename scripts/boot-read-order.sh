#!/usr/bin/env bash
# Print the READ ORDER for a session boot. No LLM required — it just emits text a session (or human)
# reads. Works as a Claude Code SessionStart hook, a shell alias, a Makefile target, or by hand.
#
# Mode detection (in priority order):
#   1. first arg: "startup" | "resume" | "clear"
#   2. JSON on stdin containing "source":"resume" (Claude Code SessionStart passes this)
#   3. default: startup
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$here/abp.conf.sh"

mode="${1:-}"
if [[ -z "$mode" ]] && payload="$(cat 2>/dev/null)"; then
  case "$payload" in
    *'"source":"resume"'*|*'"source": "resume"'*) mode="resume" ;;
    *'"source":"clear"'*|*'"source": "clear"'*)   mode="clear"  ;;
  esac
fi
[[ -z "$mode" ]] && mode="startup"

# Best-effort folder label (basename of cwd).
folder="$(basename "$PWD")"

if [[ "$mode" == "resume" ]]; then
  cat <<EOF
[boot] RESUMED session in ${folder}.
You already booted this round — do NOT re-read the full READ ORDER. Read only the DELTA:
the new round prompt, and any file it newly cites. Trust the context you already hold.
Reminder: finish the round before starting a clean session; the first message of the next
session is the next full round prompt.
EOF
  exit 0
fi

echo "[boot] Fresh session in ${folder}. READ ORDER (read large docs BY SECTION — grep the '## heading'):"
abp_print_read_order "${folder}"
echo "Acceptance: ${ABP_ACCEPTANCE}. When the round is verified, run close-round before handing back."
echo "Hard rules: never git push; never run deploy/release commands. (See CONFIGURE.md for the rest.)"
