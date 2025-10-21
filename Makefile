.PHONY: help run lint

help:
	@echo "Available targets:"
	@echo "  make run       - Run the playbook (uses scripts/inventory.py)"
	@echo "  make lint      - Run markdown lint (if mdl installed)"

run:
	ansible-playbook -i scripts/inventory.py local.yml --ask-become-pass

lint:
	@echo "Run markdown linting with 'mdl' or your preferred linter."
