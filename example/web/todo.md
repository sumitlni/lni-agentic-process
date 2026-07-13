# web — todo (open items only)

Open items only. Delete items when done (don't keep a growing done-list). Cross-folder items go here
as "surfaced to Cowork" notes.

## Open

- **UI — empty state for a filtered list with no matches.** Currently shows a blank table; add a
  "no transactions match this filter" row with a clear-filters link.
- **HUMAN — deploy the UI-5 cents formatter to staging** before API-4's cents migration lands, so the
  two match. (Waiting on you; no code action.)

## Surfaced to Cowork

- **Charts read the transaction list client-side; won't scale past ~5k rows.** Fine for now. If a
  server-side monthly aggregate is wanted, that's an `api/` round + a `docs/design.md §5` change —
  surfacing rather than building it from the web side.
