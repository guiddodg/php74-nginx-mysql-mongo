#!/bin/bash

DOCKER_BE = symfony-app


help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

run: ## Start the containers

	docker-compose up

stop: ## Stop the containers
	 docker-compose stop

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) run

build: ## Rebuilds all the containers
	 docker-compose build

prepare: ## Runs backend commands
	$(MAKE) composer-install

# Backend commands
composer-install: ## Installs composer dependencies
	 docker exec -it ${DOCKER_BE} composer install

be-logs: ## Tails the Symfony dev log
	 docker exec -it  ${DOCKER_BE} tail -f var/log/dev.log
# End backend commands

ssh-be: ## ssh's into the be container
	 docker exec -it  ${DOCKER_BE} bash

code-style: ## Runs php-cs to fix code styling following Symfony rules
	 docker exec -it  ${DOCKER_BE} php-cs-fixer fix src --rules=@Symfony