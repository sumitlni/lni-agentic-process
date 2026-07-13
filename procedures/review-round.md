# Procedure: review-round

Run by the **coordinator** when an implementer hands a round back. This is the other half of
`close-round`: the implementer prunes and hands over; you check the work and land it.

The whole point is `BUILD_PRACTICES.md` §3: **reach the round's conclusion by a different route than
the round used.** A check that retraces the round's own reasoning isn't a review — it's the same
computation, signed twice.

Two rules, and that's all:

1. **Use a different verification method than the round did.**
2. **If that isn't possible, tell the human why — and get their approval before the round is marked
   complete.** (Step 3.)

## Steps

1. **Read what the round actually claims.** Take the progress entry, the round prompt's VERIFY block,
   and any "surfaced to coordinator" notes, and write down the specific claims — numbers, behaviours,
   "X is removed", "Y is now rejected". Vague claims can't be checked; make them concrete first.

2. **For each claim, pick a DIFFERENT route than the round took.** Ask "how did the round establish
   this?", then deliberately choose another way:

   | The round's proof | Your independent route |
   |---|---|
   | computed a number from a formula | **run the authoritative producer** and read the number it emits |
   | "the old path is gone" | execute it / grep the artifact — assert the **behaviour**, not the comment |
   | added a guard test that passes | check out the **pre-round** code and show the guard **FAILS** against it |
   | "the rule is enforced" | feed it a **violating input** and watch it reject |
   | "N tests green" | ask what the test compares against — if both sides are derivations, it guards nothing |

   Never re-derive the round's own formula, never re-read its diff and nod along, and never accept
   "the tests pass" as proof of a rule.

3. **If there's no different route — say so, and ask.** It happens: the only check available is the one
   the round already ran (an authed environment you can't reach, hardware you don't have, a judgment
   call about how a screen looks). That's a legitimate outcome. Handle it like this:

   - Name **what you could not independently check**, and **why** no other route exists.
   - Say what evidence you *do* have (the round's own checks — which are still worth something, just
     not independent).
   - **Ask the human, and get approval before the round is marked complete.**

   The one thing you may never do is call it verified anyway. An unverifiable claim is fine; an
   unverifiable claim wearing a checkmark is not.

4. **Run it, don't read it.** Execute headless where you can and inspect the artifact it emits. Source
   tells you what someone *intended*; the artifact tells you what *happens*.

5. **Verify against the CODE, not the board or the notes.** Work that ships *inside* a neighbouring
   round is invisible to any tracker — no tracker records what it was never told. Before you call
   something done (or still pending), check whether the thing actually exists in the source.

6. **Write the verification note, and name the route.** "Verified ✅" with no stated path is worth
   nothing and shouldn't be accepted — including from yourself. A good note reads like:

   > Ran `<producer>` headless over `<fixtures>`; it emits **N**. The round claimed N. Separately
   > confirmed the new guard FAILS against the pre-round code.

7. **If it doesn't hold, don't fix it here.** Open a follow-up round. A reviewer who starts editing the
   code has stopped being an independent check — and now owns the bug they were supposed to catch.

8. **Land it.** Ledger entry + mark the round `done` on the status board **in the same pass**
   (`BUILD_PRACTICES.md` §10), then re-render and `--check`. Reconcile the folder's continuation files
   if the implementer left them untidy.

   **If step 3 applied — you could not verify independently — do not mark the round complete until the
   human has approved it.** Record what was unverified in the ledger entry, so the gap is on the record
   rather than in someone's memory.

## Red flags — stop and review again

- The only evidence offered is "tests pass" or "N tests green".
- Your check reproduced the round's arithmetic and got the same answer. That's an echo, not a check.
- The note says "verified" but doesn't say what was *run*.
- A number matches a **comment** or a field **name** rather than an emitted artifact.
- You reviewed it by reading the diff. Reading the diff is how you understand a change, not how you
  verify it.
