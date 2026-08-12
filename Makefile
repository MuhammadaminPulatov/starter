.DEFAULT_GOAL := help
.PHONY: help setup dev dev-queue down logs ps test lint build install doctor clean

SHELL := /bin/bash

help: ## Buyruqlar ro'yxati
	@echo "Universal Project Template"
	@echo
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "} {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	@echo

setup: ## .env yaratadi va dependencylarni o'rnatadi
	@./scripts/setup.sh

install: ## Faqat dependencylarni o'rnatadi
	@./scripts/run.sh install

dev: ## Lokal infratuzilmani ko'taradi (postgres)
	docker compose up -d
	@echo
	@docker compose ps

dev-queue: ## Infratuzilma + redis (worker uchun)
	docker compose --profile queue up -d
	@echo
	@docker compose --profile queue ps

down: ## Containerlarni to'xtatadi
	docker compose --profile queue down

logs: ## Container loglarini kuzatadi
	docker compose logs -f --tail=100

ps: ## Container holati
	docker compose ps

lint: ## Barcha topilgan app/service uchun lint
	@./scripts/run.sh lint

test: ## Barcha topilgan app/service uchun test
	@./scripts/run.sh test

build: ## Barcha topilgan app/service uchun build
	@./scripts/run.sh build

doctor: ## Repo sog'lig'ini tekshiradi (CI ham shuni chaqiradi)
	@./scripts/doctor.sh

clean: ## Containerlar va volumelarni o'chiradi (MA'LUMOT YO'QOLADI)
	@printf 'Bu database ma\''lumotlarini o\''chiradi. Davom etilsinmi? [y/N] ' && read ans && [ "$$ans" = "y" ]
	docker compose --profile queue down -v
