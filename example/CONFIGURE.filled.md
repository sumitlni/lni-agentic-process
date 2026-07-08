# CONFIGURE — Ledgerly (filled example)

## Roles

- **Coordinator:** Cowork (owns `Strategy/`, `docs/`, `current.md`, cross-folder changes).
- **Implementer:** Claude Code, launched in one folder per round.
- Coordinator-owned surfaces: `docs/`, `Strategy/`, `current.md`.

## Folders / repos

| Folder | Local checks (acceptance bar) |
|---|---|
| `web/`  | `npm test` green, `npm run build` clean, `npm run lint` clean on touched files, demo checklist |
| `api/`  | `pytest` green, `ruff` clean on touched files, demo checklist |

## Documents

- **Source of truth:** `docs/design.md`
- **As-built reference:** `docs/current-build.md`
- **Decision records:** `docs/decisions/`
- **Round prompts:** `Strategy/round-prompts.md`
- **Ledger:** `Strategy/ledger.md`
- **Presence board:** `current.md`
- **Status rollup:** none (presence board + ledger is enough at this size)

## Continuation files (per folder)

- **Progress file:** `progress.md` · **Archive:** `progress-archive.md`
- **Task file:** `todo.md`
- **Recent-rounds to keep:** 3
- **Soft token budget:** progress 6000 · task 6000
- **Budget-guard nudge threshold:** 9000

## READ ORDER

1. `CLAUDE.md` (root working model + hard rules)
2. the folder's own `README.md` / instructions
3. `docs/design.md` — only the sections the round cites
4. `docs/current-build.md` — the section for the area you're touching
5. the round prompt's remaining cited files

## Hard rules

- The human owns the dangerous verbs: agents never `git push`, never run `deploy` / release scripts.
- `docs/design.md` is authoritative; no relitigating locked decisions inside a round.
- Money math is always in integer cents, never floats (Ledgerly hard rule; decision 0002).
