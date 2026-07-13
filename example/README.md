# Example: "Ledgerly" — a filled-in instance

A small, fictional project showing the method in use. **Ledgerly** is a personal expense tracker with
two implementer folders — `web/` (a React app) and `api/` (a small service) — coordinated from a
`Strategy/` folder. Everything here is invented; it exists only to show the shape.

Files to look at, in order:

- `CONFIGURE.filled.md` — `CONFIGURE.md` with the placeholders filled in for Ledgerly.
- `CLAUDE.md` — the root agent-instructions file a session loads first (working model + hard rules +
  READ ORDER). If you use a different agent, this is just "the file your agent reads on boot."
- `current.md` — the presence board. **A lock, not a status board** — it answers "is this folder safe
  to touch right now?" and is written by the implementer.
- `Strategy/status.json` — **the status board: the single source of truth** for rounds *and* gates.
  Written by the coordinator; statuses flipped from the dashboard.
- `Strategy/queue.md` — **GENERATED** from `status.json` (`python3 status.py --render`). Never edited.
  Notice the shipped rounds (UI-7, API-4) are *absent from the view* but *retained in the JSON*.
- `web/progress.md` — a progress file done right: a `State` **pointer index** + the last 3 rounds.
- `web/todo.md` — a task file done right: open items only.
- `docs/current-build.md` — the as-built reference the progress pointers point into (one section per
  subsystem).
- `docs/decisions/0001-storage-choice.md` — a sample decision record.
- `Strategy/ledger.md` — one line per round. The archive; it carries **no status**.
- `Strategy/round-prompts.md` — a paste-ready round prompt built from the template.

Two things to notice.

**The continuation files stay tiny.** `progress.md` and `todo.md` are small, and the design detail
lives in `docs/current-build.md` one pointer away.

**There are two kinds of status, and they're stored differently.** `UI-8` is *work* — when it ships it
leaves `queue.md` automatically. `DEPLOY-CENTS` is a *gate*: a human deploy that no commit records.
Delete that row and the fact is simply gone — so it stays on the board until it's done. Conflating
these is what rots a tracker (see `BUILD_PRACTICES.md` §9).

To try it, copy `tools/status/status.py` + `STATUS.html` into `Strategy/` and run:

```
cd Strategy
python3 status.py --check     # validates the board
python3 status.py --render    # regenerates queue.md
python3 status.py             # the dashboard
```
