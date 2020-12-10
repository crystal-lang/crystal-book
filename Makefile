-include Makefile.local # for optional local config

OUTPUT_DIR ?= ./site ## Build directory (default: ./site)

MKDOCS ?= .venv/bin/mkdocs
PIP ?= .venv/bin/pip

DOCS_FILES := $(shell find docs -type f)

.PHONY: build
build: ## Build website into build directory
build: $(OUTPUT_DIR)

$(OUTPUT_DIR): $(DOCS_FILES) $(MKDOCS)
	$(MKDOCS) build -d $(OUTPUT_DIR) --strict

.PHONY: serve
serve: ## Run live-preview server
serve: $(MKDOCS)
	$(MKDOCS) serve

deps: $(MKDOCS)

$(MKDOCS): $(PIP) requirements.txt
	$(PIP) install -q -r requirements.txt

$(PIP):
	python3 -m venv .venv

.PHONY: clean
clean: ## Remove build directory
	rm -rf $(OUTPUT_DIR)

.PHONY: clean_deps
clean_deps: ## Remove .venv directory
	rm -rf .venv

.PHONY: help
help: ## Show this help
	@echo
	@printf '\033[34mtargets:\033[0m\n'
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |\
		sort |\
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo
	@printf '\033[34moptional variables:\033[0m\n'
	@grep -hE '^[a-zA-Z_-]+ \?=.*?## .*$$' $(MAKEFILE_LIST) |\
		sort |\
		awk 'BEGIN {FS = " \\?=.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo
	@printf '\033[34mrecipes:\033[0m\n'
	@grep -hE '^##.*$$' $(MAKEFILE_LIST) |\
		awk 'BEGIN {FS = "## "}; /^## [a-zA-Z_-]/ {printf "  \033[36m%s\033[0m\n", $$2}; /^##  / {printf "  %s\n", $$2}'
