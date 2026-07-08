#!/usr/bin/env bash
# ==== EDIT ME ==== — the only project-specific file in scripts/. Sourced by the other scripts.
# Everything here mirrors your CONFIGURE.md. No LLM required; plain bash.

# Values use ${VAR:-default} so an env var can override any of them (handy for CI or a one-off check),
# while the defaults here are your project's normal settings.

# --- Continuation files (looked up relative to the current folder / cwd) ---
ABP_PROGRESS_FILE="${ABP_PROGRESS_FILE:-progress.md}"
ABP_TODO_FILE="${ABP_TODO_FILE:-todo.md}"

# --- Soft budgets (tokens ≈ words × 1.3) ---
ABP_BUDGET_PROGRESS="${ABP_BUDGET_PROGRESS:-6000}"   # prune target for the progress file
ABP_BUDGET_TODO="${ABP_BUDGET_TODO:-6000}"           # prune target for the task file
ABP_GUARD_THRESHOLD="${ABP_GUARD_THRESHOLD:-9000}"   # nudge fires above this (higher than the prune target)

# --- READ ORDER printed at session boot ---
# Edit the lines to match your CONFIGURE.md. $1 = the folder name (or "this folder"), so you may
# branch per folder if you like. Keep it short — large docs are read BY SECTION, not whole-file.
abp_print_read_order() {
  local folder="${1:-this folder}"
  cat <<EOF
  1. <root agent-instructions file> (working model + hard rules)
  2. ${folder}'s own instructions file
  3. <source-of-truth doc> — only the sections the round prompt cites (read BY SECTION)
  4. <as-built reference> — the section for the area you're touching
  5. the round prompt's remaining cited files, then any design/reference material
EOF
}

# --- Local acceptance checks, shown in the boot footer (edit to your commands) ---
ABP_ACCEPTANCE="<your folder's checks: tests / build / lint> + the prompt's demo checklist"
