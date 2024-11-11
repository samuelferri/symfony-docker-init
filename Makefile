# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP) bin/console

# Misc
VENDOR_BIN  = $(PHP_CONT) ./vendor/bin/
.DEFAULT_GOAL = help

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
.PHONY        : help
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
.PHONY: build up start ps down rm logs sh bash composer test

build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub
	@$(eval c ?=)
	@$(DOCKER_COMP) up $(c)

start: build up ## Build and start the containers

ps: ## List all running containers
	@$(DOCKER_COMP) ps

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

rm: ## Stop the docker hub and remove volumes
	@$(DOCKER_COMP) down -v --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the FrankenPHP container
	@$(PHP_CONT) sh

bash: ## Connect to the FrankenPHP container via bash so up and down arrows go to previous commands
	@$(PHP_CONT) bash

test: ## Start tests with phpunit, pass the parameter "c=" to add options to phpunit, example: make test c="--group e2e --stop-on-failure"
	@$(eval c ?=)
	@$(DOCKER_COMP) exec -e APP_ENV=test php bin/phpunit $(c)


## —— Composer 🧙 ——————————————————————————————————————————————————————————————
.PHONY: composer vendor

composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
.PHONY: sf cc

sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf

## —— Database 💾  ———————————————————————————————————————————————————————————————
.PHONY: doctrine database-drop database-create database-restart migrate fixtures

doctrine: ## Run doctrine, pass the parameter "c=" to run a given command, example: make doctrine c='orm:schema-tool:create'
	@$(eval c ?=)
	@$(SYMFONY) doctrine:$(c)

database-drop: c=database:drop --force ## Drop the database
database-drop: doctrine

database-create: c=database:create ## Create the database
database-create: doctrine

database-restart: ## Restart the database
	@$(DOCKER_COMP) restart database

migrate: c=migrations:migrate ## Migrate the database
migrate: doctrine

fixtures: c=fixtures:load ## Load fixtures
fixtures: doctrine

## —— Tools 🛠  ———————————————————————————————————————————————————————————————
.PHONY: init-tools install-packages cs stan bin check

init-tools: ## Create local configuration for tools
	@$(PHP_CONT) cp .php-cs-fixer.dist.php .php-cs-fixer.php
	@$(PHP_CONT) cp phpstan.dist.neon phpstan.neon

install-packages: ## Install packages
	@$(COMPOSER) require --no-progress --update-with-all-dependencies \
		symfony/orm-pack \
		symfony/uid \
		nelmio/cors-bundle \
		--dev \
		symfony/maker-bundle \
		zenstruck/foundry \
		friendsofphp/php-cs-fixer \
		phpstan/phpstan \
		phpstan/phpstan-doctrine \
		phpstan/phpstan-phpunit \
		phpstan/phpstan-strict-rules \
		phpstan/phpstan-symfony

bin: ## Run a vendor binary, pass the parameter "c=" to run a given command, example: make bin c='phpunit'
	@$(eval c ?=)
	@$(VENDOR_BIN)$(c)

cs: ## Code style fixer
	@$(VENDOR_BIN)php-cs-fixer fix -vv

stan: ## PHPStan with PHPAT
	@$(VENDOR_BIN)phpstan analyse src --memory-limit=1G

check: cs ## Check code style and run PHPStan
check: stan
