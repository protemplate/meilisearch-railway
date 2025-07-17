# Makefile for Meilisearch Railway Template

# Default version
MEILISEARCH_VERSION ?= latest
MEILI_MASTER_KEY ?= $(shell openssl rand -base64 32)
MEILI_ENV ?= development

# Docker image name
IMAGE_NAME = meilisearch-railway-template

.PHONY: help build run test clean deploy-local deploy-railway

help: ## Show this help message
	@echo "Meilisearch Railway Template"
	@echo "============================"
	@echo ""
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build Docker image with specified version
	@echo "Building Meilisearch $(MEILISEARCH_VERSION)..."
	docker build --build-arg MEILISEARCH_VERSION=$(MEILISEARCH_VERSION) -t $(IMAGE_NAME):$(MEILISEARCH_VERSION) .

run: build ## Run Meilisearch locally
	@echo "Running Meilisearch $(MEILISEARCH_VERSION) locally..."
	@echo "Master Key: $(MEILI_MASTER_KEY)"
	docker run -d --name meilisearch-dev \
		-p 7700:7700 \
		-e MEILI_MASTER_KEY=$(MEILI_MASTER_KEY) \
		-e MEILI_ENV=$(MEILI_ENV) \
		-v meilisearch_data:/data \
		$(IMAGE_NAME):$(MEILISEARCH_VERSION)
	@echo "Meilisearch is running at http://localhost:7700"
	@echo "Master Key: $(MEILI_MASTER_KEY)"

stop: ## Stop running Meilisearch container
	@echo "Stopping Meilisearch..."
	docker stop meilisearch-dev || true
	docker rm meilisearch-dev || true

test: ## Test the Docker build and basic functionality
	@echo "Testing Meilisearch $(MEILISEARCH_VERSION)..."
	docker build --build-arg MEILISEARCH_VERSION=$(MEILISEARCH_VERSION) -t $(IMAGE_NAME):test .
	docker run -d --name meilisearch-test \
		-p 7701:7700 \
		-e MEILI_MASTER_KEY=test-key \
		-e MEILI_ENV=development \
		$(IMAGE_NAME):test
	@echo "Waiting for Meilisearch to start..."
	@sleep 10
	@echo "Testing health endpoint..."
	curl -f http://localhost:7701/health
	@echo "Testing with master key..."
	curl -H "Authorization: Bearer test-key" -f http://localhost:7701/version
	@echo "✅ Tests passed!"
	docker stop meilisearch-test
	docker rm meilisearch-test

test-versions: ## Test multiple Meilisearch versions
	@echo "Testing multiple Meilisearch versions..."
	@for version in latest v1.15 v1.14 v1.13; do \
		echo "Testing version: $$version"; \
		$(MAKE) test MEILISEARCH_VERSION=$$version; \
	done

clean: ## Clean up Docker containers and images
	@echo "Cleaning up..."
	docker stop meilisearch-dev meilisearch-test 2>/dev/null || true
	docker rm meilisearch-dev meilisearch-test 2>/dev/null || true
	docker rmi $(IMAGE_NAME):$(MEILISEARCH_VERSION) $(IMAGE_NAME):test 2>/dev/null || true
	docker volume rm meilisearch_data 2>/dev/null || true

deploy-local: ## Deploy using docker-compose
	@echo "Deploying locally with docker-compose..."
	@if [ -z "$(MEILI_MASTER_KEY)" ]; then \
		echo "MEILI_MASTER_KEY=$(shell openssl rand -base64 32)" > .env; \
	fi
	@echo "MEILISEARCH_VERSION=$(MEILISEARCH_VERSION)" >> .env
	@echo "MEILI_ENV=$(MEILI_ENV)" >> .env
	docker-compose up -d
	@echo "Meilisearch is running at http://localhost:7700"
	@echo "Master Key: $(shell grep MEILI_MASTER_KEY .env | cut -d'=' -f2)"

logs: ## Show logs from running container
	docker logs -f meilisearch-dev

shell: ## Open shell in running container
	docker exec -it meilisearch-dev /bin/sh

generate-key: ## Generate a secure master key
	@echo "Generated master key:"
	@openssl rand -base64 32