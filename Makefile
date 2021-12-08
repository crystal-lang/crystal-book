-include Makefile.local # for optional local config

OUTPUT_DIR ?= ./site ## Build directory (default: ./site)

MKDOCS ?= .venv/bin/mkdocs
PIP ?= .venv/bin/pip

DOCS_FILES := $(shell find docs -type f)

.PHONY: build
build: ## Build website into build directory
build: $(OUTPUT_DIR)

$(OUTPUT_DIR): $(DOCS_FILES) $(MKDOCS) mkdocs.yml
	$(MKDOCS) build -d $(OUTPUT_DIR) --strict

.PHONY: serve
serve: ## Run live-preview server
serve: $(MKDOCS) mkdocs.yml
	$(MKDOCS) serve

deps: $(MKDOCS)

$(MKDOCS): $(PIP) requirements.txt
	$(PIP) install -q --no-deps -r requirements.txt && touch $(MKDOCS)

$(PIP):
	python3 -m venv .venv

.PHONY: vendor
vendor: ## Install assets from external sources
vendor: carcin-play codemirror ansi_up

.PHONY: carcin-play
carcin-play: docs/assets/vendor/carcin-play/carcin.js docs/assets/vendor/carcin-play/carcin-play.js docs/assets/vendor/carcin-play/carcin-play.css docs/assets/vendor/carcin-play/codemirror-theme.css

docs/assets/vendor/carcin-play/%:
	mkdir -p $(@D)
	curl -sL -o $@ https://github.com/straight-shoota/carcin-play/raw/master/$(@F)

.PHONY: codemirror
codemirror: docs/assets/vendor/codemirror/codemirror.min.css docs/assets/vendor/codemirror/codemirror.min.js docs/assets/vendor/codemirror/mode/crystal/crystal.min.js

docs/assets/vendor/codemirror/%:
	mkdir -p $(@D)
	curl -sL -o $@ https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.59.4/$(@F)

docs/assets/vendor/codemirror/mode/crystal/crystal.min.js:
	mkdir -p $(@D)
	curl -sL -o $@ https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.59.4/mode/crystal/crystal.min.js

.PHONY: ansi_up
ansi_up: docs/assets/vendor/ansi_up/ansi_up.min.js

docs/assets/vendor/ansi_up/%:
	mkdir -p $(@D)
	curl -sL -o $@ https://cdn.jsdelivr.net/npm/ansi_up@5.0.0/$(@F)

.PHONY: clean
clean: ## Remove build directory
	rm -rf $(OUTPUT_DIR)

.PHONY: clean_deps
clean_deps: ## Remove .venv directory
	rm -rf .venv

.PHONY: clean_vendor
clean_vendor: ## Remove docs/assets/vendor directory
	rm -rf docs/assets/vendor

.PHONY: clean_all
clean_all: clean clean_deps clean_vendor

.PHONY: format_api_docs_links
format_api_docs_links:
	echo $(DOCS_FILES) | xargs sed -i -E -e 's|https?://(www\.)?crystal-lang.org/api/([A-Z])|https://crystal-lang.org/api/latest/\2|g'

.PHONY: check_internal_links
check_internal_links: $(DOCS_FILES)
	if grep -P '\[\w.*?\]\((?!http)[^ )]*?(\.html|/)(#[^ )]*?)?\)' docs/**/*.md; then \
		echo "Links within the site must end with .md"; exit 1; \
	fi
	if grep -P '\]\(/|//crystal-lang.org/reference/' docs/**/*.md; then \
		echo "Absolute links within the site are disallowed, use relative links instead"; exit 1; \
	fi

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
