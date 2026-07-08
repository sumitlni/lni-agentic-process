# 0001 — Storage: SQLite for v1

Status: Accepted (2026-02-10)

## Context

Ledgerly v1 is single-user, self-hosted, low write volume. We need durable storage for transactions
and categories without operational overhead.

## Decision

Use SQLite (one file per user) for v1. No client-server database.

## Consequences

- Zero-ops: no separate DB process to run or back up beyond copying the file.
- Simple migrations (a numbered SQL folder run at startup).
- Not suitable for multi-user concurrency — revisit if Ledgerly goes multi-tenant (would be a new
  decision, not an edit to this one).

## Refinement (2026-03-01)

API-4 introduced an integer-cents money column; see decision 0002. No change to the storage engine.
