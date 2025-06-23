# Rails Application Makefile
# Usage: make <command>

.PHONY: help lint lint-fix test db-migrate db-seed server

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

lint: ## Run RuboCop linting (check only)
	bundle exec rubocop

lint-fix: ## Run RuboCop and auto-fix issues
	bundle exec rubocop -a

lint-fix-all: ## Run RuboCop and auto-fix all possible issues
	bundle exec rubocop -A

test: ## Run all tests
	bundle exec rails test

db-migrate: ## Run database migrations
	bundle exec rails db:migrate

db-seed: ## Seed the database
	bundle exec rails db:seed

server: ## Start the Rails server
	bundle exec rails server

setup: ## Initial setup (migrate + seed)
	$(MAKE) db-migrate
	$(MAKE) db-seed 