# Ledgerly web — Current build (as-built reference)

As-built state, one section per subsystem. NOT authoritative — where it disagrees with
`docs/design.md`, the design wins and this doc is stale (fix it). Read the ONE section for the area
you're touching, by heading.

## Transactions

`web/src/pages/Transactions.tsx` renders a sortable, paginated table of transactions (`useQuery`
`listTransactions`). Search box (full-text over payee + note) and a single-select **category filter**
sit above the table; both write URL params (`?q=&category=`) so views are shareable. Rows link to the
edit drawer. Amounts render via `formatCents()` — the list never receives floats.

## Editing

Add/edit is an inline drawer (`web/src/components/TxDrawer.tsx`), not a modal page — click a row or "+
New". The amount field is a cents-only masked input (`CentsInput`); save is optimistic with rollback
on error. No route change; the drawer is URL-synced (`?edit=<id>` / `?new=1`).

## Auth

Email magic-link (`/auth/request` → `/auth/verify`); the session is an httpOnly cookie set by `api/`.
The web app only reads `useSession()`; there is no token in JS.

## Charts

`web/src/pages/Insights.tsx` shows monthly spend by category, computed **client-side** from the loaded
transaction list (`groupByMonthCategory`). No chart library — a small hand-built SVG bar set. Known
limit: recomputes from the full list, so it won't scale past a few thousand rows (see todo.md).
