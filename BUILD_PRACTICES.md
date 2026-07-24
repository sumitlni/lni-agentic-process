# Agentic Build Practices — the method

A model- and tool-agnostic way to build software with coding agents. This is the method I arrived at
building my own products, with everything specific to those products stripped out — folder names,
checks, hard rules, file paths and budgets all live in `CONFIGURE.md`. Read this once; keep
`CONFIGURE.md` open while you adopt.

Throughout, **"agent"** means whatever is doing the work — Claude Code, Cowork, a local model behind
an agent CLI, or you following the same steps. Nothing here requires a specific LLM.

---

## 1. Two tiers: coordinator and implementer

The single biggest decision. Split the work into two roles and encode the boundary so neither has to
remember it:

- **Coordinator** — owns the cross-cutting surfaces: specs, decisions, the presence board, the round
  ledger, and any change spanning more than one folder/repo. It **drafts round prompts and reviews
  results.** It does *not* write feature code.
- **Implementer** — is launched in **exactly one folder/repo** and executes **one round** end-to-end:
  reads its prompt, edits code there, runs that folder's checks, updates that folder's progress + task
  files.

Why it works: coordination needs to see the whole product and lock decisions for everyone;
implementation needs to disappear into one folder and ship one change well. Mixing them in a single
session makes both worse.

**Pause-and-surface.** If an implementer finds itself needing to edit a folder it wasn't launched in
(or a coordinator-owned surface), it **pauses and writes a "surfaced to coordinator" note** in its own
folder's task file, then stops. Reads across folders are always fine; writes are not.

Concrete instantiations: Cowork (coordinator) + Claude Code (implementer); or one long-running "planning"
chat + a fresh "doing" agent per round; or you as coordinator + any single agent as implementer.

---

## 2. Rounds: the unit of work

A **round** is a numbered, scoped change — the contract between coordination and implementation.

- One round may have **per-folder blocks** run as separate sessions. Do the cheapest-surface work
  first (often the front-end / the layer that needs no infra).
- Every paste-ready prompt uses a **four-backtick outer fence** (prompts contain triple-backtick code
  samples), opens with a one-line **round banner inside the fence**, then `READ ORDER`, `WORK TO DO`,
  `MUST NOT`, and a **close-out** step. See `procedures/round-prompt-template.md`.
- **Cite by section + line-range**, not "somewhere in X."
- **Lock the spec, then implement.** Land the decision/spec change *before* the prompt that cites it,
  so the implementer reads a stable spec.
- **Split a round when scope grows:** keep the number for the smaller piece, add a letter suffix for
  the follow-up (Round 12 / Round 12A); track both.
- **Draft a dependent round against the real tree, not one about to change.** If a round's shape depends
  on an entity or contract a *predecessor* creates, capture its scope now but write the full prompt
  *after* the predecessor lands — against the shipped shape, not a guess. Pre-writing it anchors it on
  code that's about to move.
- **Renames and sweeps: census the token's SENSES first; split on a hidden contract.** The same token is
  often an entity in one place and a DOM property, a role name, or a coordinate in others — classify
  every hit and find the shared-contract ones *before* touching, then confirm by running the consumer to
  see what it actually reads. If a token you were told to rename turns out to be a shared-engine/contract
  field, **prove it by running (not reading) and hand back an evidenced split — never a half-job.** A
  blind find-replace corrupts the ones that only looked alike.
- Prompts and their outcomes are recorded in a **ledger** (one line per round).

---

## 3. Verification must take a DIFFERENT PATH than the round's proof

**A check that retraces the round's own reasoning is not verification — it is duplication.** The
reviewer has to reach the conclusion by a **different route** than the one the round used to produce
it. Two computations of the same wrong model agreeing is not evidence; it is the same error, signed
twice.

This is the same rule the method enforces on code — one fact, one copy — applied to the act of
checking. The point of a review pass is to be a second, *independent* source. If it isn't independent
it's theatre, and worse than nothing: it launders a wrong answer into a verified one.

It binds the **coordinator** hardest, since the coordinator reviews what the implementer produced. The
last three rules bind the implementer too.

**Two carve-outs, and only two.** Skip the independent path when the check is *trivial* — one fact any
two readers compute identically (does this route equal that literal string?) — or when no independent
route is feasible (last rule). Everything else gets the second path. And this matters **more**, not
less, as you mix models: when the implementer might be a smaller local model, an independent check —
ideally by a *different, stronger* agent — is your main defense against a confidently wrong result that
reads as done. Cross-model review (one model implements, another verifies by a different route) is the
mixed-LLM version of this rule.

The coordinator's checklist for this lives in `procedures/review-round.md`.

**The rules**

- **Never re-implement the round's logic to check the round's logic.** If the round computed a number
  from a formula, do **not** recompute that formula. **Run the authoritative producer** — the engine,
  the real function, the actual artifact — and compare against *that*.
- **Never trust a name.** A field called `itemCount`, a comment claiming "the old path is gone", a test
  named `rejects_bad_input` — assert the **behaviour**. Read the emitted object, not the label on it.
- **"The tests pass" is not proof of a rule.** A test can lock in the wrong number. Ask what the test
  compares *against*: **if both sides are derivations, it guards nothing.** A new guard must be shown to
  **FAIL against the pre-round code** — otherwise you haven't shown it can fail at all.
- **Prefer running to reading.** Execute it headless and inspect the artifact it produces. Source tells
  you what someone *intended*; the artifact tells you what *happens*.
- **Prefer the LIVE system to the code, once it's deployed.** Verify *behaviour on the running system* —
  call the real endpoint, read what actually comes back — not the source that claims to produce it.
  Source can be correct while the deploy that carries it is stale. This is the strongest independent path
  there is: it clears every layer between the code and the user in one shot. (Corollary: make the running
  system *tell you what it is* — see §11.)
- **State the route you took.** A verification note must name the independent source it checked against.
  "Verified ✅" with no stated path is worth nothing, and shouldn't be accepted.
- **If no independent route exists, say so and ask.** Sometimes the only check available is the one the
  round already ran — an authed environment you can't reach, hardware you don't have, a judgment call
  about how a screen looks. That's allowed. What is **not** allowed is quietly calling it verified.
  Tell the human what you *couldn't* check and why, and get their approval before the round is marked
  complete. An unverifiable claim is fine; an unverifiable claim wearing a checkmark is not.

**Where this came from — both directions, in one week.**

*The good case.* A round hoisted a set of duplicated rules into a shared engine. Every ruling was
checked by **running** the engine headless and asserting the behaviour it actually produced — not by
reading the diff and agreeing with it. Independent path, real confidence.

*The failure.* A round computed a design size as `rows × steps`. To "verify" it, I recomputed **the same
formula** over the same fixtures, got the same answers, and reported *"0 mismatches, independently
verified."* It was not independent — it re-ran the round's own premise, and the premise was wrong. The
real generator emits one item per *run*, and for one shape of input it emits **2** where the formula
says **4**. Running the generator — the thing that actually produces the output — would have caught it
in one command. Instead the wrong number shipped **with a guard test locking it in**, and surfaced later
only because the next session happened to read its own work.

The tell, in hindsight: *the reviewer never executed the code that owns the rule.*

(Same instinct as §10's "verify against the code, not the board" — applied to a round instead of the
tracker.)

---

## 4. Source-of-truth vs as-built — and read by section

Keep two kinds of document apart:

- **Source of truth** — the *intended* model/design. Authoritative. Prompts cite it by section; they
  never restate it.
- **As-built reference** — what each subsystem *currently* looks like, sectioned by subsystem, read on
  demand for the area you're touching. **Not** authoritative: where it disagrees with the source of
  truth, the source of truth wins and the as-built doc is stale (fix it).

**Read by section, never whole-file.** Any "the file is too big to read in one shot" limit is a
*whole-file* limit. Grep the `## heading` and read a bounded range around it and file size stops
mattering — no matter how large the doc grows. Quick size check: `words × ~1.3 ≈ tokens`.

This split is also what lets the progress file (below) stay tiny: the durable design detail lives in
the as-built doc, and progress just points at it.

---

## 5. Continuation files: a write budget, enforced

Each folder keeps two continuation files (names are yours — set in `CONFIGURE.md`; commonly
`progress.md` and `todo.md`). They are **continuation state, not a changelog**:

- **Progress file** — a `State` block that is a **pointer index**: one line (≤2) per subsystem pointing
  to where the real detail lives (the as-built doc section + the source-of-truth section). Plus the
  **last N rounds** (default 3) at ≤2 lines each. Older rounds move to an archive file. It never
  re-narrates the design.
- **Task file** — **open items only.** Delete every item whose round shipped, including settled
  "as-shipped / judgment-call" write-ups (that history is in git + the decision record + the round
  prompt). Keep open work, human-pending items, and un-rolled-up "surfaced" notes.

**Why it drifts without enforcement:** rounds *append* and nothing *prunes*. The fix is to make the
prune mechanical — see the **close-round** procedure (§8) — and to nudge when files exceed budget
(`scripts/check-budget.sh`). Set your soft budget in `CONFIGURE.md` (a few thousand tokens each is a
sane default).

**Counter-pattern:** a task file is an action list, not history. Keep it manageable by **deletion**,
not by splitting.

---

## 6. Decision capture

Treat *decisions* and *implementation* as separate first-class artifacts. Capture a cross-cutting
decision once, with enough context that a future reader understands what was chosen and why;
implementation references it.

- Number them; **one file per decision** (e.g. `NNNN-short-name.md`). Once accepted, don't rewrite in
  place — append new information as a dated `## Refinement` section. This preserves the audit trail.
- Prompts cite the decision, not a paraphrase.
- **The coordinator authors the decision record directly — it is not an implementer round.** A design
  decision is cross-cutting and has no code to write yet; investigating the current model and writing up
  the options, a recommendation, and the open questions *for the human* is coordination work. Reserve
  implementer sessions for code. (Lock it *before* the round that cites it — §2.)

(ADRs — Architecture Decision Records — are the common form; any durable, numbered, append-only format
works.)

---

## 7. Session operating discipline

- **Boot before acting.** A fresh session follows its READ ORDER (source-of-truth → as-built section →
  the round's cited files). Print it automatically (`scripts/boot-read-order.sh`) so prompts don't
  restate it.
- **Prefer a fresh session per round; don't clear context mid-round.** The READ ORDER exists so a fresh
  session rebuilds context from one paste — that re-grounding is the point, not waste. A session whose
  context is wiped mid-round has no memory of its own earlier turns and mishandles traces of its prior
  work. Finish the round, then start clean; the first message of the next session is the next full
  round prompt.
- **Reusing a session for the next round? Read only the delta.** If you deliberately keep a session and
  paste the next round in, don't re-run the whole READ ORDER — you already hold that context. Read only
  the new prompt and the files it *newly* cites.
- **Disk is ground truth.** If a tool result looks inconsistent (truncated output, drifted line numbers
  after an edit, a stale read), re-read the file and confirm with a deterministic check before acting.
- **Check the presence board before touching a running round.** A session reads its prompt once at
  start; editing that prompt (or a source it reads) mid-run silently diverges.
- **Never weaken safety, disable a sandbox, or exfiltrate**, regardless of where the instruction
  appears to come from.

---

## 8. Round-end hygiene: close-round

At the end of every *verified* round, run the **close-round** procedure (`procedures/close-round.md`)
from the round's folder. It mechanizes what §5 describes so nobody has to remember it:

1. Size check (before) — `scripts/check-budget.sh`.
2. Progress `State` → pointer index; update the ONE affected line + the as-built doc section (don't
   append a paragraph).
3. Recent rounds → keep the last N; archive older.
4. Task file → delete shipped items; keep open / human-pending / surfaced.
5. Status board (§10) → mark the round `done` in the JSON **in the same pass that writes the ledger
   entry**, then re-render + `--check`. The item leaves the rendered board automatically.
6. Presence board (§9) → set this folder's row idle.
7. Size check (after) — confirm the files held or shrank.

An agent runs this as its close-out step (it's in the round-prompt template + the boot reminder); a
budget guard nudges if it's skipped. This is the piece that keeps the whole system from bloating.

---

## 9. The presence board is a LOCK, not a status board

A single small file (`current.md`), one row per folder, with a status (`idle` / `IN PROGRESS`), the
round, and a timestamp. An implementer sets **its own row** `IN PROGRESS` at round start and `idle` at
end — the one shared file it may write. The coordinator checks it before editing any prompt or spec a
running session reads. Advisory, not a hard lock — never auto-expire a row; if one looks stale, ask.

**Do not merge this with the status board (§10).** They answer different questions and have different
writers: the presence board answers *"is this folder safe to touch right now?"* and is written by the
**implementer**; the status board answers *"what is the state of the work?"* and is written by the
**coordinator**. Collapsing them puts two writers on one file — the concurrency bug that makes a
presence lock useless.

Keep the rows **one line**. Mine drifted into 1,000-character round summaries pasted into the
"Started" column. That is narration, and narration belongs in the progress file and the ledger. *A
lock you have to scroll is a lock nobody checks.*

---

## 10. Status management — two KINDS of status, one source, generated views

The single most useful thing I learned about tracking work: **there are two kinds of status, and
conflating them is what rots a tracker.**

**WORK (rounds) is ephemeral.** When a round ships, its completion is already fully recorded — in the
code, in git, in the ledger. So the **rendered board drops it**: the board shows only work that is
still real, and the file a session reads at boot cannot fill up with things that no longer matter. The
item stays in the *store* as history; it just stops being *shown*. Delete-on-ship applies to the
**view**, not the store.

**GATES are durable.** "Engine tagged v0.10.0." "Migration 0004 applied to staging but not prod."
"Store approved build 42." These are facts about the world — human-gated, external, **with no commit
and no code to grep**. Delete one and it is simply gone; there is no other copy. Gates must be
**stored**, with a state and a date, and stay visible until they reach a terminal state.

The trap is treating all status as one kind. Delete-on-ship applied to a gate loses the only record
you had. Accumulate-forever applied to a round produces the lie described at the end of this section.

### The mechanism: one source, generated views

**One JSON file is the single source of truth** — every round and every gate. Each item carries
`id, module, type, title, status, owner, note, ref, sec` (+ optional `blocked_by`, `drafted`). `type`
is what separates the two kinds: `round` (work) vs `ops` / `launch` (gates); `doc` for the
coordinator's own jobs.

**Everything you read is GENERATED and marked `DO NOT EDIT`:**

| command | what it does |
|---|---|
| `python3 status.py` | serves the editable dashboard; click a badge to change a status |
| `python3 status.py --check` | **validates the board; non-zero exit** |
| `python3 status.py --render` | regenerates the markdown board (`queue.md`) |
| `python3 status.py --render --check-sync` | fails if the board is stale vs the JSON |

The rendered board is committed so sessions read it at boot without running anything; a status change
via the dashboard re-renders it automatically, so the two cannot drift. The tooling ships in
`tools/status/` and is project-agnostic — `project`, `subtitle`, and `modules` come from the JSON, so
the same files drop into any repo unchanged.

**Never hand-maintain a markdown board *and* a JSON file.** That is two copies of one fact — the
disease, not the cure. Prose that matters (why an item is parked, the hazard on a gate) lives in the
item's `note` field and is *rendered*; it is never retyped into the markdown.

### Dependencies are a FIELD, not prose

`blocked_by: [ids]`, and **blocked is DERIVED, never stored** — an item is blocked when any blocker
isn't `done`, so the flag cannot go stale. The dashboard refuses to mark a blocked item `active`: it
should not let you lie to yourself about what you can work on. A "ready to go" list answers the only
question that matters most mornings — *what can I actually start right now?*

I found, on a real board, a note reading *"device QA needs OPS-5 and OPS-4, then commit"* — a hard
dependency, stored as **prose**, on an item the dashboard was cheerfully showing as actionable. OPS-4
was still pending. **If a fact governs what you can do next, it needs a field and a
check, not a sentence.**

### The part that makes it work: the script must CHECK, not just render

A tracker nobody verifies is a rumour. Rendering a dashboard over an unchecked file just renders the
lie faithfully, in colour. So `--check` fails loudly on:

- a blocker that doesn't resolve, and dependency **cycles**;
- an item marked `active` while blocked, or `done` while still blocked;
- a **drafted round whose prompt file doesn't exist on disk**;
- a `deferred` item with **no stated reason** (if you can't say why it waits, it isn't real work);
- duplicate ids;
- a presence-board row saying `IN PROGRESS` with no active round — **the reverse direction, which is
  the drift nobody thinks to look for**.

Then `--check-sync` guarantees the generated views match the source. That is what makes "generated"
safe: *a generated file nobody regenerates is just a stale file with extra steps.*

**Write the checker's negative tests.** Feed it a dangling blocker, a cycle, a missing prompt file —
and confirm it exits non-zero on each. My first run of this checker produced two false positives (it
matched the presence board's own documentation prose for "IN PROGRESS", and rejected a `ref` pointing
at a directory). *A validator you haven't tried to break is just another unverified file.*

### Verify against the CODE, not the board

Before declaring a round pending — or done — check whether the thing it asks for **already exists**.
Work that ships *inside a neighbouring round* is invisible to any tracker, because no tracker records
what it was never told. I found a round sitting marked "drafted" for five days after it had shipped;
a `grep` for the component it was supposed to create found it, complete, with the round's own name in
the comment. No status file can catch that. Only reading the code can.

### The rules

- **One writer per file, and never edit the DERIVED view to change what it shows.** The coordinator
  edits the JSON — when it drafts a round, and on every verification pass. You flip statuses from the
  dashboard (which writes the same file). **Nobody edits the rendered board or the dashboard HTML.**
  *I broke this once: to make a single item read "ready," an agent widened the readiness predicate in
  the dashboard code itself — which silently reflagged four unrelated items and broke the view.
  Readiness is DERIVED; the fix was a one-field change in the source, not the renderer. If a derived
  view shows the wrong thing, the bug is in the data, not the deriver.* (The presence board is a
  *different* file with a different writer — see §9. Don't merge them.)
- **Ship = mark `done` in the JSON, in the same pass that writes the ledger entry.** The item then
  leaves the *rendered* board automatically. It is retained in the JSON — that is the history, and for
  a gate it is the *only* record that exists.
- **Every blocked or parked item states its blocker or its reason** — `blocked_by` for the first,
  `note` for the second, and `--check` **fails** if a parked item has no reason. This is not
  bookkeeping: one parked item on my board hid a "Validate" button that performs a **real data
  import** against an un-deployed backend. A row reading only "deferred" is an invitation for someone
  to pick it up.
- **Sections are states, not epics.** LIVE / READY / BLOCKED / GATES / BACKLOG / PARKED. Group by
  *what you can act on*, not by *what it belongs to* — an epic grouping is what lets shipped and
  unshipped work sit adjacent and look alike.
- **A dashboard is only as good as the check underneath it.** It is safe here *because* `--check` runs
  against the same JSON and fails loudly — not because it is pretty.

### The failure this replaced

Worth reading before you decide you don't need any of this. I ran a combined status/archive ledger
for months. By the time I looked hard at it, it was 2,504 lines and **actively lying**:

- a grep for pending items returned **21 rounds. Three were real.** The other 18 had shipped.
- The cause was mechanical, not careless: ship-time notes were **appended as new sections** rather than
  flipping the original checkbox. Every round then existed **twice, in two states**, and a grep found
  the stale one first.
- One round still read "ready to run" while I was actively debugging the very page it described.

This is the **same failure as duplicated code**: one fact, two copies, no test. I'd spent the
preceding weeks pulling exactly that out of a codebase — and was running my own process on it.
**A status field that must be kept in sync by discipline will drift, in prose exactly as in code.** The
fix is the same in both places: keep one copy, and test it.

### The ledger, afterwards

The ledger keeps its real job — newest-at-top, one entry per round: scope, decisions, the bugs it
killed, the rulings that settled an argument. **Read it to understand *why* something is the way it
is; never to find out what to do next.** Open it with a banner saying so, because its historical prose
still contains sentences that were true when written and are lies now.

---

## 11. Deploying: make it observable — and check parity

The human owns the deploy verbs (§12), but the *method* still has three things to say about release —
all learned the same week, all about not guessing.

**Stamp every deployed surface with what it is.** A build id — a commit short-SHA plus a timestamp —
rendered in the UI **and** returned in every API/tool response. Without it, "is my change live yet?" is
a guess you burn round-trips inferring from behaviour; with it, a reviewing agent confirms a deploy by
reading the SHA off one response. Capture the id **at build time from the pipeline** (the CI job knows
the commit it's shipping) — **never commit it into the source**, which is a chicken-and-egg. And beware
a naive "is the tree dirty?" check: with no pipeline id set it falls back to local git, and untracked
build artifacts (a cache dir, a build-output folder) flip it to a false *dirty*. *We chased a phantom
`-dirty` badge on a clean release for exactly this reason.*

**Budget for propagation lag in post-deploy checks.** An empty or stale result *right after* a deploy is
often the surface not having propagated yet (or data not re-seeded) — **not** a defect. Read the build
stamp before you conclude anything. *A new grouping came back empty on the first re-import because it ran
against the not-yet-deployed client; the identical import on retry populated it. Diagnosing that as a
code bug would have burned a round.*

**When two surfaces share a contract, check PARITY before the deploy gate.** If a client and a server
(or two services) write the same store or share a wire format and are built **in parallel**, a blocker
found in one must propagate to the other — and the gate must assert the two still **agree** (same keys,
same names). Neither side's own tests can catch this; it's an emergent, cross-surface property. *A
rename ran client and server in parallel; the client hit a shared-engine blocker and correctly stopped
after one of three renames while the server did all three. Each was internally green. Shipping them
together would have split the store — caught only by comparing the two contracts directly.* This gets
sharper in a mixed-model shop, where the two surfaces may be built by different agents that never see
each other's reasoning.

---

## 12. Hard rules (you fill these in)

A few decisions should be **hard rules** — non-negotiable, override default behavior, no relitigation
without changing the source of truth. They exist because they're easy to violate by accident and
expensive to clean up. Keep them few, absolute, and read on every boot. Define yours in `CONFIGURE.md`.
Two that nearly every project wants:

- **The human owns the dangerous verbs.** Agents never `git push` and never run deploys/releases —
  under any circumstances. Local commits/diffs are fine; pushing and shipping stay with you.
- **Designate a source of truth** and forbid relitigating locked decisions inside a round; changes go
  through the decision record + the source-of-truth doc first.

---

## 13. Adopt it

See `docs/ADOPTING.md` for a step-by-step, and `example/` for a small filled-in instance. The shortest
path: fill `CONFIGURE.md`, drop in `scripts/`, wire one integration (`integrations/claude-code/` or
`integrations/generic/`), and run your first round with the template in `procedures/round-prompt-template.md`.
