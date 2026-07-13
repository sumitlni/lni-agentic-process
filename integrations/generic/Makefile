# Agentic Build Practices — generic wiring (works with any agent or none).
# Assumes scripts/ is at the repo root. Run these from the folder you're working a round in.

SCRIPTS ?= scripts
STATUS  ?= Strategy          # the folder holding status.py + status.json (see CONFIGURE.md)

.PHONY: boot boot-resume budget status status-render close-round review-round help

help:
	@echo "make boot           - print the READ ORDER for a fresh session"
	@echo "make boot-resume    - print the 'read only the delta' reminder for a continued session"
	@echo "make budget         - show continuation-file sizes vs budget"
	@echo "make status         - VALIDATE the status board (non-zero exit on error)"
	@echo "make status-render  - regenerate the rendered board (queue.md) from status.json"
	@echo "make close-round    - size check + status check + the close-round procedure to follow"
	@echo "make review-round   - the coordinator's review checklist (verify by a DIFFERENT path)"

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

review-round:
	@echo "Coordinator review — follow procedures/review-round.md"
	@echo "  The rule: reach the conclusion by a DIFFERENT route than the round used."
	@echo "  Re-deriving the round's own formula is not a check; run the authoritative producer."
	@echo "  Name the route in your note. Then: make status-render && make status"

close-round:
	@bash $(SCRIPTS)/check-budget.sh
	@echo ""
	@echo "Now follow procedures/close-round.md (steps 2-6). Remember:"
	@echo "  - mark the round done in status.json in the SAME pass as the ledger entry"
	@echo "  - add any new GATE (deploy/migration/tag/approval) — nothing else records it"
	@echo "  - then: make status-render && make status && make budget"
