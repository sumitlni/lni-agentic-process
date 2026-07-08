# Example: "Ledgerly" — a filled-in instance

A small, fictional project showing the method in use. **Ledgerly** is a personal expense tracker with
two implementer folders — `web/` (a React app) and `api/` (a small service) — coordinated from a
`Strategy/` folder. Everything here is invented; it exists only to show the shape.

Files to look at, in order:

- `CONFIGURE.filled.md` — `CONFIGURE.md` with the placeholders filled in for Ledgerly.
- `CLAUDE.md` — the root agent-instructions file a session loads first (working model + hard rules +
  READ ORDER). If you use a different agent, this is just "the file your agent reads on boot."
- `current.md` — the presence board.
- `web/progress.md` — a progress file done right: a `State` **pointer index** + the last 3 rounds.
- `web/todo.md` — a task file done right: open items only.
- `docs/current-build.md` — the as-built reference the progress pointers point into (one section per
  subsystem).
- `docs/decisions/0001-storage-choice.md` — a sample decision record.
- `Strategy/ledger.md` — one line per round.
- `Strategy/round-prompts.md` — a paste-ready round prompt built from the template.

Notice how small `progress.md` and `todo.md` stay, and how the design detail lives in
`docs/current-build.md` one pointer away — that's the whole point.
