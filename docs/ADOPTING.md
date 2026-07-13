# Adopting Agentic Build Practices

A step-by-step to go from zero to running rounds. Budget about 30 minutes for the first pass — most
of it is describing your project once, in `CONFIGURE.md`, so you never have to describe it again.

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

## 4. Set up the status board

Copy `tools/status/` (`status.py` + `STATUS.html`) into your process folder — one level below the repo
root, e.g. `Strategy/`. Create `status.json` beside them; `example/Strategy/status.json` is a working
starting point. Set `project`, `subtitle`, and `modules[]`, then add one item per round and one per
**gate** (a deploy, a migration, a tag, an approval — anything human or external that no commit
records).

```
cd Strategy
python3 status.py --check     # validates: dangling blockers, cycles, parked-with-no-reason, …
python3 status.py --render    # generates queue.md — commit it; never edit it
python3 status.py             # the dashboard; click a badge to change a status
```

Two rules that make it worth having: **the coordinator is the only one who hand-edits `status.json`**,
and **a shipped round is marked `done` in the same pass that writes the ledger entry** — it then leaves
the rendered board on its own. Full reasoning in `BUILD_PRACTICES.md` §9.

## 5. Wire one integration

- **Claude Code / Cowork:** follow `integrations/claude-code/README.md` (copy `dot-claude/` → `.claude/`).
- **Anything else (local LLM, other agent, manual):** follow `integrations/generic/README.md`
  (Makefile + git pre-commit).

Both call the same scripts — pick whichever matches how you drive your agent. You can switch later.

## 6. Set up the shared files

- Create the **presence board** (one row per folder; see `example/current.md`).
- Create the **ledger** (one line per round).
- Make sure each folder has its **progress** + **task** files, starting lean (a `State` heading with
  pointer lines, and an empty `Open` list). See `example/`.

## 7. Run your first round

1. Draft the round prompt from `procedures/round-prompt-template.md`. Lock any spec/decision change
   first.
2. Launch a fresh implementer session in the target folder; it boots via the READ ORDER, does the
   work, runs the checks.
3. At the end, it runs **close-round** (the skill, `make close-round`, or by hand) — pruning the
   continuation files and setting its presence row idle.
4. The coordinator reviews, lands the ledger entry, and reconciles the files if needed.

## 8. Keep it honest

- If the progress `State` starts growing paragraphs, that's design detail leaking in — move it to the
  as-built doc, leave a pointer.
- If the task file starts collecting "as-shipped" notes, close-round isn't running — check your
  close-out step and the budget guard.
- Revisit `CONFIGURE.md` as the project grows (new folder → new row, new checks).

## Publishing your own project? Scrub before you push

The **only** file that reveals project specifics is your filled `CONFIGURE.md` (and the
`# ==== EDIT ME ====` block in `scripts/abp.conf.sh`). Review those before open-sourcing. The method,
procedures, and scripts are generic by design.
