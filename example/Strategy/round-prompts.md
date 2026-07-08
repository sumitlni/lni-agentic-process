# Ledgerly — round prompts

Paste-ready, ascending, newest appended. Built from `procedures/round-prompt-template.md`.

## UI-7 — category filter on the transactions list

````
UI-7 — add a single-select category filter to the transactions list, URL-synced and sharing state
       with the existing search. Does NOT touch the edit drawer or the API.
Launch folder: web
Depends on: none.

READ ORDER
1. CLAUDE.md → web/README.md → docs/design.md §3 (transactions list).
2. docs/current-build.md § Transactions.
3. web/src/pages/Transactions.tsx (the search box + URL-param wiring, ~lines 40-90);
   web/src/lib/categories.ts (the category list).

WORK TO DO
1. Add a category <select> beside the search box; options from `categories.ts` + an "All" default.
2. Bind it to a `category` URL param (like `q`); filtering is client-side over the loaded list.
3. Search + category compose (AND). Clearing either updates the URL.
4. Tests: the filter predicate (category + search compose) and the URL round-trip.

MUST NOT
- Touch the edit drawer, the API, or the money formatter. git push / deploy.

VERIFY
- npm test + npm run build green; lint clean on touched files. Demo: pick a category → list narrows,
  URL shows ?category=…, shareable; combine with search; "All" clears.

CLOSE-OUT
- Run close-round: update the § Transactions line in progress State + docs/current-build.md,
  keep the last 3 rounds, trim todo.md, set web's current.md row to idle, surface the ledger entry.
````
