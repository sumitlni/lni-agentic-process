# Integration: generic (Makefile + git hooks) — for local LLMs or any tool

No Claude-specific features. This wires the same `scripts/` into a Makefile and a git pre-commit hook,
so the method works with a local model behind any agent CLI, a different agent, or just you at a
terminal. I keep this path working deliberately — I don't want the method to depend on one vendor.

## Install

```
cp integrations/generic/Makefile <repo>/Makefile     # or merge the targets into your existing one
cp integrations/generic/git-hooks/pre-commit <repo>/.git/hooks/pre-commit
chmod +x scripts/*.sh <repo>/.git/hooks/pre-commit
```

Edit `scripts/abp.conf.sh` for your file names, budgets, and READ ORDER.

## Use

- `make boot` — print the READ ORDER for a fresh session. Paste it (or its output) at the top of your
  agent's context. With a local LLM, prepend this to your system/first message.
- `make boot-resume` — print the "read only the delta" reminder for a continued session.
- `make budget` — show current continuation-file sizes vs budget.
- `make close-round` — print the close-round procedure to follow (then do it, or hand it to your
  agent). It also runs the before/after size checks.

## How it maps to the method

| Method piece (BUILD_PRACTICES.md) | Generic wiring |
|---|---|
| Boot READ ORDER (§6) | `make boot` / `make boot-resume` |
| Write-budget nudge (§4) | `pre-commit` hook runs `budget-guard.sh` |
| close-round (§7) | `make close-round` prints `procedures/close-round.md` |

## Local-LLM tip

Agents driven by smaller local models benefit most from the boot step and the pointer-index progress
file: the whole point is to feed the model a short, accurate context instead of a bloated one. Keep
your budgets tighter (`scripts/abp.conf.sh`) if your model's context window is small.
