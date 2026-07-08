# Agentic Build Practices

A small, model-agnostic method for building real software with coding agents without drowning in
context bloat, re-grounding cost, and drift.

It is the distillation of running many agent "rounds" across multi-repo products: what kept the
work fast, the context lean, and the humans in control. The method is plain prose and plain bash —
**it does not depend on any particular LLM or agent tool.** Most people will run it with Claude Code
/ Cowork, but it works just as well with a local model, another agent CLI, or a human following the
same checklist.

## The problems it solves

- **Context bloat.** Progress and task files grow every round until an agent can't read them in one
  shot and re-reading them is expensive.
- **Re-grounding cost.** Every fresh agent session has to rebuild its understanding of the project.
  If your notes are fat, that's slow and lossy; if the boot steps aren't written down, it's
  inconsistent.
- **Drift.** Notes-as-changelog, todo-as-done-list, and "the design doc and the code disagree" all
  creep in unless something actively prunes and reconciles.
- **Loss of control.** Agents that commit, push, or deploy on their own turn a productivity tool
  into a liability.

## The core ideas

1. **Two tiers.** A **coordinator** owns cross-cutting surfaces (specs, decisions, cross-repo
   changes) and writes work prompts + reviews results. An **implementer** is scoped to *one* folder
   and executes *one* round end-to-end. Keep them separate; mixing them makes both worse. (e.g.
   Cowork + Claude Code — but equally "you + one agent," or two runs of a local model.)
2. **Rounds.** The unit of work is a numbered **round** with a paste-ready prompt: a READ ORDER, the
   work, a MUST-NOT list, and a close-out step.
3. **Source-of-truth vs as-built.** The *intended* design and the *as-built* notes are different
   documents. Read them **by section**, never whole-file — so file size stops mattering.
4. **A write budget, enforced.** Progress files are a pointer index + the last few rounds; task
   files are open items only. A **close-round** procedure prunes them every round so they never
   bloat.
5. **Cheap, consistent boot.** A **boot** step prints the READ ORDER so prompts don't restate it,
   and tells a *resumed* session to read only the delta.
6. **Human owns the dangerous verbs.** Agents never push or deploy. Full stop.

## What's in the box

```
BUILD_PRACTICES.md          The method (model- and tool-agnostic). Start here.
CONFIGURE.md                The instance layer — the placeholders each project fills in.
procedures/
  close-round.md            The round-end hygiene procedure (any agent or human can follow).
  round-prompt-template.md  A paste-ready round-prompt skeleton.
scripts/                    Plain bash, no LLM required.
  check-budget.sh           Reports token-ish sizes of your progress/task files.
  boot-read-order.sh        Prints the folder-aware READ ORDER (startup vs resume).
integrations/
  claude-code/              Wire it as Claude Code / Cowork skills + hooks.
  generic/                  Wire it with a Makefile + git hooks — for local LLMs / any tool.
docs/ADOPTING.md            Step-by-step adoption.
example/                    A small fictional project showing the method in use.
```

## Quick start

1. Read `BUILD_PRACTICES.md`, then copy `CONFIGURE.md` and fill in your project's specifics
   (folders, checks, hard rules, file locations, token budgets).
2. Copy `scripts/` into your repo and edit the `# ==== EDIT ME ====` block at the top of each.
3. Pick an integration: `integrations/claude-code/` (skills + hooks) or `integrations/generic/`
   (Makefile + git hooks). Both call the same scripts.
4. Look at `example/` to see a filled-in instance end to end.

## Design principle: method vs instance

Everything project-specific lives in **`CONFIGURE.md`** and the `# ==== EDIT ME ====` blocks — never
in the method. That's what makes this reusable and safe to share: the method is universal, and your
folders, domain terms, and rules stay in your own copy.

## License

MIT — see `LICENSE`. Use it, fork it, adapt it.
