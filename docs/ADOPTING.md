# Adopting Agentic Build Practices

A step-by-step to go from zero to running rounds. Budget ~30 minutes for the first pass.

## 1. Read the method

Read `BUILD_PRACTICES.md` once. You don't need to memorize it — it's the reference — but understand
the two tiers, the round loop, and the write budget.

## 2. Fill in your instance

Copy `CONFIGURE.md` into your repo and replace every `<…>`:

- your coordinator + implementer (what runs each);
- your folders and each one's local checks (the acceptance bar);
- your source-of-truth doc and your as-built doc (create the as-built doc if you don't have one — it
  can start as a single heading per subsystem);
- your continuation-file names, archive file, recent-rounds count, and token budgets;
- your READ ORDER;
- your hard rules (keep "no push / no deploy" unless you have a strong reason not to).

## 3. Drop in the scripts

```
cp -r scripts <your-repo>/scripts
chmod +x scripts/*.sh
$EDITOR scripts/abp.conf.sh      # mirror the values from your CONFIGURE.md
```

Sanity-check:

```
cd <a folder that has a progress file>
bash ../scripts/check-budget.sh          # sizes
bash ../scripts/boot-read-order.sh        # your READ ORDER prints
```

## 4. Wire one integration

- **Claude Code / Cowork:** follow `integrations/claude-code/README.md` (copy `dot-claude/` → `.claude/`).
- **Anything else (local LLM, other agent, manual):** follow `integrations/generic/README.md`
  (Makefile + git pre-commit).

Both call the same scripts — pick whichever matches how you drive your agent. You can switch later.

## 5. Set up the shared files

- Create the **presence board** (one row per folder; see `example/current.md`).
- Create the **ledger** (one line per round).
- Make sure each folder has its **progress** + **task** files, starting lean (a `State` heading with
  pointer lines, and an empty `Open` list). See `example/`.

## 6. Run your first round

1. Draft the round prompt from `procedures/round-prompt-template.md`. Lock any spec/decision change
   first.
2. Launch a fresh implementer session in the target folder; it boots via the READ ORDER, does the
   work, runs the checks.
3. At the end, it runs **close-round** (the skill, `make close-round`, or by hand) — pruning the
   continuation files and setting its presence row idle.
4. The coordinator reviews, lands the ledger entry, and reconciles the files if needed.

## 7. Keep it honest

- If the progress `State` starts growing paragraphs, that's design detail leaking in — move it to the
  as-built doc, leave a pointer.
- If the task file starts collecting "as-shipped" notes, close-round isn't running — check your
  close-out step and the budget guard.
- Revisit `CONFIGURE.md` as the project grows (new folder → new row, new checks).

## Publishing your own project? Scrub before you push

The **only** file that reveals project specifics is your filled `CONFIGURE.md` (and the
`# ==== EDIT ME ====` block in `scripts/abp.conf.sh`). Review those before open-sourcing. The method,
procedures, and scripts are generic by design.
