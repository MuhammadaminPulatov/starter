.DEFAULT_GOAL := help
.PHONY: help setup dev dev-queue down logs ps test lint lint-sh build install doctor clean

SHELL := /bin/bash

help: ## List every command
	@echo "Universal Project Template"
	@echo
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "} {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "  Script language: STARTER_LANG=en|uz|ru (auto-detected by default)"
	@echo

setup: ## Create .env and install dependencies
	@./scripts/setup.sh

install: ## Install dependencies only
	@./scripts/run.sh install

dev: ## Start local infrastructure (postgres)
	docker compose up -d
	@echo
	@docker compose ps

dev-queue: ## Infrastructure plus redis (for the worker)
	docker compose --profile queue up -d
	@echo
	@docker compose --profile queue ps

down: ## Stop the containers
	docker compose --profile queue down

logs: ## Follow container logs
	docker compose logs -f --tail=100

ps: ## Container status
	docker compose ps

lint: ## Lint every detected app/service
	@./scripts/run.sh lint

lint-sh: ## Lint this repository's own shell scripts (needs shellcheck)
	@shellcheck scripts/*.sh scripts/lang/*.sh && echo "shellcheck: clean"

test: ## Test every detected app/service
	@./scripts/run.sh test

build: ## Build every detected app/service
	@./scripts/run.sh build

doctor: ## Check repository health (CI runs this too)
	@./scripts/doctor.sh

clean: ## Remove containers and volumes (DATA IS LOST)
	@printf 'This deletes the database data. Continue? [y/N] ' && read ans && [ "$$ans" = "y" ]
	docker compose --profile queue down -v
