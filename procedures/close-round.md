# Procedure: close-round

Run at the **end of a verified round**, from the round's folder, to keep the continuation files lean.
This is a plain procedure — any agent or a human can follow it. On Claude Code it's packaged as a
skill (`integrations/claude-code/`); with the generic integration it's `make close-round`. It does the
same steps either way.

Prerequisite: the round is verified (your folder's checks pass, the demo/acceptance step is done).
Names and budgets below come from your `CONFIGURE.md`.

## Steps

1. **Size check (before).** Run `scripts/check-budget.sh` (or `make budget`). Note where the progress
   and task files stand against the soft budget.

2. **Progress `State` → pointer index.** The `State` block is one line (≤2) per subsystem, pointing to
   the as-built doc section + the source-of-truth section. If this round changed a subsystem's as-built
   shape, update **that one line** and edit the matching **as-built doc section** — do not append a new
   paragraph to `State`. If it added a new subsystem, add one pointer line + one as-built section.

3. **Recent rounds → keep the last N, archive the rest.** Keep the most recent N (from `CONFIGURE.md`,
   default 3) at ≤2 lines each. Move older entries to the archive file (append, verbatim, newest
   first). Leave a final pointer line: `Older rounds → <archive file>`.

4. **Task file → open items only.** Delete every item whose round shipped — including settled
   "as-shipped / deviation / judgment-call" write-ups (that history is in git + the decision record +
   the round prompt). Keep: genuinely open work, human-pending items (deploys, data cleanup, manual
   captures), and un-rolled-up "surfaced to coordinator" notes. If unsure whether an item is still
   open, ask — don't retain by default.

5. **Reconcile the layers (if you use a status rollup).** In the same pass, set this round's item
   `status` in the rollup **and** tick/annotate the matching entry in this folder's task file, so the
   rollup and the detail never drift. If you have no rollup, skip.

6. **Ledger + presence board.**
   - If you're the **coordinator**, add/close this round's one-line ledger entry.
   - If you're the **implementer**, you don't edit coordinator-owned files — instead leave a one-line
     "surfaced to coordinator" note with the ledger entry, and set only **your folder's row** in the
     presence board to `idle`.

7. **Size check (after).** Re-run `scripts/check-budget.sh`. Confirm both files held or shrank. If the
   progress `State` is still over budget, the leftover prose is design detail that belongs in the
   as-built doc — move it.

## Boundary reminder

An implementer edits only its own folder's continuation files and its own presence-board row.
Coordinator-owned surfaces (ledger, status rollup, specs, decisions) are reconciled by the coordinator
— surface to it, don't reach across.
