# Round-prompt template

Copy the block below for each round. Use a **four-backtick outer fence** so triple-backtick code
samples inside survive copy-paste. Fill the `<…>` placeholders. Keep it self-contained: a fresh
session should be able to execute the whole round from this one paste.

`````
````
<ROUND-ID> — <one-line scope>. <one line on what it explicitly does NOT touch>.
Launch folder: <folder>
Depends on: <none | ROUND-ID(s)>. <serialize/parallelize note>

READ ORDER
1. <root agent-instructions> → <folder agent-instructions> → <source-of-truth section(s) cited>.
2. <as-built section for this area>.
3. <the specific source files, with line numbers when known — "see `fn` (~line NNN)">.

WORK TO DO
1. <step, concrete and testable>.
2. <step>.
3. <tests to add / update>.

MUST NOT
- <tempting-but-wrong changes>, <out-of-scope folders>, <anything that violates a hard rule>.
- git push; run any deploy/release command. (Leave changes in the working tree for the human.)

VERIFY
- <folder checks: tests/build/lint green> + <the manual demo/acceptance checklist>.

CLOSE-OUT
- Run the close-round procedure: prune the progress State to a pointer + update the as-built section,
  keep the last N rounds (archive older), trim the task file to open items, set this folder's presence
  row to idle, surface the ledger entry to the coordinator.
````
`````

## Notes

- **One folder per round block.** If a round spans folders, write one block per folder and run each in
  its own session; do the cheapest-surface one first.
- **Cite, don't restate.** Point at the source-of-truth section; never paste the design into the
  prompt.
- **The CLOSE-OUT line is what keeps the system lean** — don't drop it. The boot step also reminds the
  session, and the budget guard nudges if it's skipped, but naming it here makes it reliable.
