# Agentic Build Practices — generic wiring (works with any agent or none).
# Assumes scripts/ is at the repo root. Run these from the folder you're working a round in.

SCRIPTS ?= scripts
STATUS  ?= Strategy          # the folder holding status.py + status.json (see CONFIGURE.md)

.PHONY: boot boot-resume budget status status-render close-round help

help:
	@echo "make boot           - print the READ ORDER for a fresh session"
	@echo "make boot-resume    - print the 'read only the delta' reminder for a continued session"
	@echo "make budget         - show continuation-file sizes vs budget"
	@echo "make status         - VALIDATE the status board (non-zero exit on error)"
	@echo "make status-render  - regenerate the rendered board (queue.md) from status.json"
	@echo "make close-round    - size check + status check + the close-round procedure to follow"

boot:
	@bash $(SCRIPTS)/boot-read-order.sh startup

boot-resume:
	@bash $(SCRIPTS)/boot-read-order.sh resume

budget:
	@bash $(SCRIPTS)/check-budget.sh

status:
	@python3 $(STATUS)/status.py --check

status-render:
	@python3 $(STATUS)/status.py --render

close-round:
	@bash $(SCRIPTS)/check-budget.sh
	@echo ""
	@echo "Now follow procedures/close-round.md (steps 2-6). Remember:"
	@echo "  - mark the round done in status.json in the SAME pass as the ledger entry"
	@echo "  - add any new GATE (deploy/migration/tag/approval) — nothing else records it"
	@echo "  - then: make status-render && make status && make budget"
