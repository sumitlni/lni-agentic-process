---
name: review-round
description: >
  Run by the COORDINATOR to review a round an implementer just handed back — before marking it done.
  Use when a round comes back for review (e.g. "review this round", "verify the round", "check the
  round before I land it"). Enforces the rule that a review must reach the conclusion by a DIFFERENT
  path than the round used: run the authoritative producer, assert behaviour not names, show a new
  guard fails against pre-round code, and name the route you took. Then land the ledger entry + the
  status board in one pass.
---

# review-round

The Claude Code packaging of `procedures/review-round.md` (repo root). Follow that procedure; this file
is the entry point.

**Two rules:**

1. **Use a different verification method than the round did** (`BUILD_PRACTICES.md` §3). Re-deriving
   the round's own formula and getting the same answer is not verification — it's the same computation,
   signed twice.
2. **If a different method isn't possible, tell the human why, and get approval before marking the
   round complete.** Sometimes the only check available is the one the round already ran (an authed
   environment you can't reach, hardware you don't have, a judgment call about how a screen looks).
   That's fine — say what you couldn't check and why, then ask. Never call it verified anyway.

## The pass

- Write down the round's **concrete claims** (numbers, behaviours, "X removed", "Y rejected").
- For each, pick a route the round did **not** take:
   - it computed a number from a formula → **run the authoritative producer** and read what it emits;
   - it says something is gone → **execute/inspect the artifact**, don't trust the comment or the name;
   - it added a passing guard → show that guard **FAILS against the pre-round code**;
   - it says a rule is enforced → feed it a **violating input** and watch it reject.
- **Run, don't read.** Prefer executing headless and inspecting the emitted artifact over reading source.
- **Verify against the CODE, not the board** — work can ship inside a neighbouring round and be
  invisible to any tracker.
- **Name the route in your verification note.** "Verified" with no stated path is not a result.
- If it doesn't hold, **open a follow-up round — don't fix it yourself.** A reviewer who edits the code
  stops being an independent check.
- Land it: ledger entry + mark `done` in `status.json` in the **same pass**, then
  `python3 status.py --render && python3 status.py --check`. **If rule 2 applied, get the human's
  approval first, and record what was unverified in the ledger entry.**

Details + the failure that produced this rule: `BUILD_PRACTICES.md` §3 and §10.
