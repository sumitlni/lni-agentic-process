# web — progress (continuation state)

Continuation state for a fresh session — not a changelog, not the design.

- `## State` is a POINTER INDEX: one line per subsystem → `docs/current-build.md § …` + `docs/design.md § …`.
- `## Recent rounds` keeps the last 3; older → `progress-archive.md`.
- close-round enforces this at round end.

## State

- **Transactions list** — table with search + category filter, URL-synced. → current-build § Transactions · design §3.
- **Add/edit transaction** — inline drawer, cents-only amount input, optimistic save. → current-build § Editing · design §3.
- **Auth** — email magic-link, session in httpOnly cookie. → current-build § Auth · design §2.
- **Charts** — monthly spend by category (client-side from the loaded list). → current-build § Charts · design §5.

Source of truth: `docs/design.md`.

## Recent rounds

- **UI-7** — category filter on the transactions list (single-select, URL-synced, shares state with search). Tests green, build/lint clean. Prompt: UI-7.
- **UI-6** — transactions table replaces the old card grid (sortable, paginated). Tests green. Prompt: UI-6.
- **UI-5** — cents-only amount input + display formatter (no floats reach the UI). Tests green. Prompt: UI-5.
- Older rounds → `progress-archive.md`.
