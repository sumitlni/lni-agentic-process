# Integration: Claude Code / Cowork

Wires the method into Claude Code (and Cowork) via a skill + two hooks. All three just call the plain
bash in `scripts/` — the logic is model-agnostic; this is only the wiring. It's how I run it day to
day, but nothing in the method depends on it.

## Install

1. Copy `scripts/` to your repo root (and edit `scripts/abp.conf.sh`).
2. Copy this folder's `dot-claude/` to your repo root as `.claude/`:
   ```
   cp -r integrations/claude-code/dot-claude <repo>/.claude
   chmod +x scripts/*.sh
   ```
   (It's shipped as `dot-claude/` because some tools hide/skip dotfiles; rename it to `.claude/`.)
3. If you already have a `.claude/settings.json`, **merge** the `hooks` block rather than overwriting.

## What each piece does

- **`.claude/skills/close-round/SKILL.md`** — the round-end hygiene skill. The coding session invokes
  it as its close-out step; it runs `scripts/check-budget.sh` and follows `procedures/close-round.md`.
- **SessionStart hook** → `scripts/boot-read-order.sh` — prints the READ ORDER on a fresh session and
  a "read only the delta" note on a resumed one, so round prompts don't restate the boot steps.
- **Stop hook** → `scripts/budget-guard.sh` (with `ABP_EMIT_JSON=1`) — nudges the session to run
  close-round if the continuation files are over budget. Silent otherwise.

## Notes

- The hooks use `$CLAUDE_PROJECT_DIR` so they work regardless of which folder the session launched in.
- `boot-read-order.sh` reads the SessionStart payload on stdin to tell startup from resume — no config
  needed.
- Nothing here is required: you can skip the hooks and just invoke the skill, or skip the skill and
  follow `procedures/close-round.md` by hand.
