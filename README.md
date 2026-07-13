# Agentic Build Practices

A model-agnostic method for building real software with coding agents — without drowning in context
bloat, re-grounding cost, and drift. Three ideas: split planning from doing, work in numbered
**rounds**, and keep your notes on a budget that something actually enforces.

This is a generalized description of the Agentic Engineering process I follow with my own products.
It's the process I describe in this LinkedIn series:

- Part 1 — Turning a non-deterministic tool into predictable software: [link](https://lnkd.in/p/gtDmhUME)
- Part 2 — The data constraint that forced real engineering: [link](https://lnkd.in/p/gW3q5x97)
- Part 3 — "Give it the keys and let it drive": [link](https://lnkd.in/p/giQxy7jC)
- Part 4 — The missing pieces: decision records and an orchestrator: [link](https://lnkd.in/p/gp6nnfD5)
- Part 5 — Conclusion and final thoughts: [link](#)

I will keep updating this as the process evolves. I'd love to hear your thoughts on how to make it better.

## What's in the box

```
BUILD_PRACTICES.md          The method (model- and tool-agnostic). Start here.
CONFIGURE.md                The instance layer — the placeholders you fill in.
procedures/
  close-round.md            The round-end hygiene procedure (any agent or you can follow it).
  round-prompt-template.md  A paste-ready round-prompt skeleton.
scripts/                    Plain bash, no LLM required.
  check-budget.sh           Reports token-ish sizes of your progress/task files.
  boot-read-order.sh        Prints the folder-aware READ ORDER (startup vs resume).
tools/status/               The status board — stdlib Python, drops into any repo.
  status.py                 Serve the dashboard · --check (validate) · --render (regenerate).
  STATUS.html               The dashboard. Click a badge to change a status.
integrations/
  claude-code/              Wire it as Claude Code / Cowork skills + hooks.
  generic/                  Wire it with a Makefile + git hooks — for local LLMs / any tool.
docs/ADOPTING.md            Step-by-step adoption.
example/                    A small fictional project showing the method in use.
```

## Getting started

The idea: leave the method alone, and put everything about your project in one config file. So setup
is quick.

1. **Read `BUILD_PRACTICES.md` once.** It's short. You just need three ideas: split planning from
   doing, work in numbered rounds, and keep your notes on a budget.
2. **Fill in `CONFIGURE.md`.** Copy it and replace the `<…>` placeholders with your folders, your test
   commands, your rules. This one file is your whole setup.
3. **Add the scripts.** Copy `scripts/` in and edit the one marked block at the top of
   `scripts/abp.conf.sh`.
4. **Set up the board.** Copy `tools/status/` into your process folder, write a small `status.json`
   (see `example/Strategy/status.json`), and run `python3 status.py --check`.
5. **Wire it up.** Use `integrations/claude-code/` if you're on Claude Code / Cowork, or
   `integrations/generic/` (a Makefile + git hook) for a local model or any other tool.
6. **Run a round.** Draft a prompt from `procedures/round-prompt-template.md` and go.

New to it? Read `example/` first — a tiny finished project that shows every file done right.

## What to know before you adopt

A few things here are deliberate, and a little different from how people usually work with agents:

- **Nothing about your project lives in the method.** It all goes in `CONFIGURE.md`. That's what makes
  this reusable — and it means you only have one file to check before you open-source your own repo.
- **Your progress and todo files stay small on purpose.** Progress is a short index that points at the
  detail; the todo is open items only. Close-round prunes them every round, and your agent runs it —
  you don't have to remember.
- **Start each round fresh.** A clean session rebuilds context from one paste; don't wipe context
  mid-round. It sounds wasteful, but it's what keeps the agent accurate. (I learned this the expensive
  way — see the series.)
- **Two kinds of status, and a tracker that gets checked.** Shipped work leaves the board — git and the
  ledger already record it. Gates (a deploy, a migration, a tag, an approval) stay, because nothing
  else records them. One JSON file is the truth, the board is generated from it, and a checker fails
  loudly when it starts lying.
- **It's not tied to Claude.** The core is plain text and plain bash. Most people will run it with
  Claude, but a local model or any other agent works just as well.
- **You keep the keys.** Agents never push or deploy — that stays with you.
- **Take as little as you want.** Just the note discipline, or just the boot step, and add the rest
  later. It's not all-or-nothing.

## License

MIT — see `LICENSE`. Use it, fork it, adapt it. If it saves you a few hours of re-explaining your own
project to an agent, that's the whole point.
