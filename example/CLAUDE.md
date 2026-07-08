# Ledgerly — root orientation (read first)

This file auto-loads for every agent session. It encodes the working model and the hard rules so
neither tier has to remember them. Full method: `agentic-build-practices/BUILD_PRACTICES.md`; our
specifics: `CONFIGURE.filled.md`.

## Repo map

- `web/` — the React app. Web rounds launch here.
- `api/` — the Python service. API rounds launch here.
- `docs/` — `design.md` (source of truth) + `current-build.md` (as-built, sectioned) + `decisions/`.
- `Strategy/` — process only: `round-prompts.md`, `ledger.md`.
- `current.md` — presence board.

## Working model — coordinator ↔ implementer

- **Coordinator (Cowork)** owns `docs/`, `Strategy/`, `current.md`, and anything spanning folders;
  drafts round prompts and reviews. Does not write feature code.
- **An implementer session is launched in ONE folder** and does one round: reads its prompt, edits
  there, runs the folder's checks, updates that folder's `progress.md` + `todo.md`, and runs
  **close-round** at the end.
- **Pause-and-surface:** need to edit another folder? Write a "surfaced to Cowork" note in your
  folder's `todo.md` and stop.
- Root files are coordinator-only, except a session sets its **own row** in `current.md`.

## Session boot READ ORDER

`CLAUDE.md` (this) → the folder's instructions → `docs/design.md` (by section) →
`docs/current-build.md` (the area's section) → the round prompt's cited files. Read large docs **by
section**, not whole-file.

## Hard rules

- **Never `git push`; never run deploys/releases.** The human does that.
- **`docs/design.md` is authoritative.** No relitigating locked decisions inside a round.
- **Money is integer cents, never floats** (decision 0002).
