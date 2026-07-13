# CONFIGURE — your instance layer

Everything project-specific lives here (and in the `# ==== EDIT ME ====` blocks of `scripts/`). The
method (`BUILD_PRACTICES.md`) never changes; this file is where your project's reality goes. That
split is the whole trick — it's what lets me share the method without shipping my products with it.
Fill it in, keep it in your repo, and cite it from your root agent-instructions file.

Copy this file, replace every `<…>`, and delete the guidance lines you don't need.

## Roles

- **Coordinator:** `<what runs the coordinator — e.g. Cowork, a planning chat, you>`
- **Implementer:** `<what runs one round in one folder — e.g. Claude Code, a local model via an agent CLI>`
- Coordinator-owned surfaces (implementers never write these): `<list — e.g. specs dir, decisions dir,
  the presence board, the ledger, cross-folder changes>`

## Folders / repos

List each folder an implementer can be launched in, with its local checks (the acceptance bar for a
round in that folder):

| Folder | Local checks (acceptance bar) |
|---|---|
| `<folder-a>` | `<e.g. unit tests green, build clean, lint clean on touched files, demo checklist>` |
| `<folder-b>` | `<…>` |

## Documents

- **Source of truth (authoritative intended model):** `<path>`
- **As-built reference (sectioned, read on demand):** `<path>`
- **Decision records:** `<dir — e.g. docs/adr/>`
- **Round prompts:** `<path>`
- **Ledger (one line per round — archive, carries NO status):** `<path>`
- **Presence board (a LOCK, not a status board):** `<path — e.g. current.md>`

## Status board (BUILD_PRACTICES §9)

Drop `tools/status/` into your process folder and create `status.json` beside it.

- **Source of truth:** `<path — e.g. Strategy/status.json>` (hand-edited only by the coordinator;
  statuses flipped by you from the dashboard)
- **Rendered board (GENERATED — never edit):** `<path — e.g. Strategy/queue.md>`
- **Validator + dashboard:** `<path — e.g. Strategy/status.py + STATUS.html>`
- **Modules** (the `modules[]` in your JSON — each item must belong to one):
  `<e.g. Frontend, Backend, Cross-cutting>`
- **Item types:** `round` = work (leaves the rendered board when done) · `ops` / `launch` = a **gate**
  (human/external, no commit records it — stays visible until done) · `doc` = a coordinator job.

Run `python3 status.py --check` in a git hook or CI; it exits non-zero so it can gate.

## Continuation files (per folder)

- **Progress file name:** `<e.g. progress.md>`  ·  **Archive file:** `<e.g. progress-archive.md>`
- **Task file name:** `<e.g. todo.md>`
- **Recent-rounds to keep in the progress file:** `<N, default 3>`
- **Soft token budget (prune trigger):** progress `<e.g. 6000>` · task `<e.g. 6000>`
- **Budget-guard nudge threshold:** `<e.g. 9000>` (higher than the prune target, so it only trips on
  real bloat)

## READ ORDER (printed at session boot)

The ordered list a fresh session should read. Keep it short; large docs are read *by section*.

1. `<root agent-instructions file>`
2. `<the folder's own instructions file>`
3. `<source of truth — only the sections the round cites>`
4. `<as-built reference — the section for the area you're touching>`
5. `<the round prompt's remaining cited files, then any design/reference material>`

## Hard rules (non-negotiable)

- The human owns the dangerous verbs: agents never `git push`, never run deploys/releases.
- `<your source of truth>` is authoritative; no relitigating locked decisions inside a round.
- `<add project-specific hard rules — naming locks, gated areas, "reference not snapshot", etc.>`

## Notes

- Keep this file free of secrets. It describes *where things live and what the rules are*, not
  credentials.
- If you open-source your project, this file is the only one that reveals project specifics — review
  it before publishing.
