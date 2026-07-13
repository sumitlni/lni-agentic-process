# Active sessions — presence board

**This is a LOCK, not a status board.** It answers one question: *is this folder safe to touch right
now?* The work's status lives in `Strategy/status.json` (rendered to `queue.md`) — a different file,
with a different writer. Don't merge them; two writers on one file is what makes a lock useless.

One row per implementer folder, **one line each**. A session sets its own row to `IN PROGRESS` at round
start and back to `idle` at round end (via close-round). The coordinator checks this before editing any
prompt/spec a running session reads. Never auto-expire a row — if one looks stale, ask.

| Folder | Status | Round  | Started (UTC)        |
|--------|--------|--------|----------------------|
| web    | idle   | UI-7   | 2026-03-04 — UI-7 shipped (category filter on the transactions list). |
| api    | idle   | API-4  | 2026-03-02 — API-4 shipped (cents-only money type + migration).       |
