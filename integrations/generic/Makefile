# Agentic Build Practices — generic wiring (works with any agent or none).
# Assumes scripts/ is at the repo root. Run these from the folder you're working a round in.

SCRIPTS ?= scripts

.PHONY: boot boot-resume budget close-round help

help:
	@echo "make boot         - print the READ ORDER for a fresh session"
	@echo "make boot-resume  - print the 'read only the delta' reminder for a continued session"
	@echo "make budget       - show continuation-file sizes vs budget"
	@echo "make close-round   - run the size check + print the close-round procedure to follow"

boot:
	@bash $(SCRIPTS)/boot-read-order.sh startup

boot-resume:
	@bash $(SCRIPTS)/boot-read-order.sh resume

budget:
	@bash $(SCRIPTS)/check-budget.sh

close-round:
	@bash $(SCRIPTS)/check-budget.sh
	@echo ""
	@echo "Now follow procedures/close-round.md (steps 2-6), then re-check:"
	@echo "  make budget"
