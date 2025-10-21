.PHONY: help install run lint test clean

help:
	@echo "Available targets:"
	@echo "  make install   - Install Python dependencies"
	@echo "  make run      - Run the playbook (uses scripts/inventory.py)"
	@echo "  make lint     - Run all linters (ansible-lint, yamllint, markdownlint)"
	@echo "  make test     - Run ansible-playbook in check mode"
	@echo "  make clean    - Clean up temporary files"

install:
	python3 -m pip install -r requirements.txt

run:
	ansible-playbook -i scripts/inventory.py local.yml --ask-become-pass

lint:
	yamllint -d relaxed .
	ansible-lint
	markdownlint '**/*.md'

test:
	ansible-playbook -i scripts/inventory.py local.yml --check --diff

clean:
	find . -name "*.retry" -delete
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete
