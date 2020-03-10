# Makefile for building crystal-book

BUNDLE := bundle
JEKYLL := $(BUNDLE) exec jekyll
HTMLPROOF := $(BUNDLE) exec htmlproofer

BUILD_DIR := _site
PORT := 4000

.PHONY: all
all: build

.PHONY: install
install: Gemfile
	$(BUNDLE) check > /dev/null || $(BUNDLE) install --path vendor/bundler

.PHONY: update
update: Gemfile
	$(BUNDLE) update

$(BUILD_DIR): install source/**
	$(JEKYLL) build --destination $@ --trace

.PHONY: build
build: $(BUILD_DIR)

.PHONY: serve
serve: install
	$(JEKYLL) serve --watch --livereload --incremental --destination $(BUILD_DIR) --port=$(PORT)

.PHONY: check
check: $(BUILD_DIR)
	$(JEKYLL) doctor
	$(HTMLPROOF) \
		--check-html \
		--http-status-ignore 999 \
		--internal-domains localhost:4000 \
		--assume-extension \
		$(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	rm -rf .jekyll-cache
