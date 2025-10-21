.PHONY: help install install-deps run lint lint-ansible lint-markdown test clean

help:
	@echo "Available targets:"
	@echo "  make install        - Install Python dependencies"
	@echo "  make install-deps   - Install all dependencies (Python and Node.js)"
	@echo "  make run           - Run the playbook (uses scripts/inventory.py)"
	@echo "  make lint          - Run all linters"
	@echo "  make lint-ansible  - Run ansible-lint and yamllint"
	@echo "  make lint-markdown - Run markdownlint (requires Node.js)"
	@echo "  make test          - Run ansible-playbook in check mode"
	@echo "  make clean         - Clean up temporary files"

install:
	python3 -m pip install -r requirements.txt

install-deps: install
	@which npm >/dev/null 2>&1 || { echo "npm is required but not installed. Install Node.js first."; exit 1; }
	sudo npm install -g markdownlint-cli

run:
	ansible-playbook -i scripts/inventory.py local.yml --ask-become-pass

lint: lint-ansible lint-markdown

lint-ansible:
	yamllint -d relaxed .
	ansible-lint

lint-markdown:
	@which markdownlint >/dev/null 2>&1 || { echo "markdownlint-cli is not installed. Run 'make install-deps' first."; exit 1; }
	markdownlint '**/*.md'

test:
	ansible-playbook -i scripts/inventory.py local.yml --check --diff

clean:
	find . -name "*.retry" -delete
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete
