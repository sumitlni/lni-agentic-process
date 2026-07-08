---
name: close-round
description: >
  Run at the END of a verified round, from the round's folder, to keep the continuation files lean.
  Use when a round is done and you're about to hand back (e.g. "close out this round", "wrap the
  round", "run close-round"). Prunes the progress file's State to a pointer index, archives older
  rounds, deletes shipped task items, reconciles any status rollup, and sets this folder's presence
  row to idle. Folder-scoped — the coordinator does the cross-folder rollup.
---

# close-round

This skill is the Claude Code packaging of the project-agnostic procedure in
`procedures/close-round.md` (repo root). Follow that procedure; this file just gives you the entry
points.

Run only after the round is **verified** (your folder's checks pass, the demo/acceptance step is done).

1. Size check (before): run `bash scripts/check-budget.sh` from the round's folder.
2. Follow **`procedures/close-round.md`** steps 2–6:
   - progress `State` → pointer index (update the one affected line + the as-built doc section; don't
     append a paragraph);
   - keep the last N rounds, archive older;
   - task file → open items only (delete settled write-ups);
   - reconcile the status rollup + task file in the same pass (if you use a rollup);
   - ledger + presence board: implementers surface the ledger entry and set only their own row to
     idle; the coordinator lands the ledger entry.
3. Size check (after): re-run `bash scripts/check-budget.sh`; confirm both files held or shrank.

Boundary: edit only this folder's continuation files and its own presence-board row. Coordinator-owned
surfaces are surfaced to, not reached across. Details + rationale: `BUILD_PRACTICES.md` §4, §7, §8.
