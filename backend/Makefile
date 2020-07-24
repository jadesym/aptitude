# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

##
## This makefile is allows for the following commands:
##
## COMMAND         | Description
##--------------------------------------------------------------------
DOCKER_COMPOSE_MAIN_FILE_NAME = docker-compose.yml
DOCKER_COMPOSE_LINT_FILE_NAME = docker-compose.lint.yml
DOCKER_COMPOSE_E2E_TEST_FILE_NAME = docker-compose.e2e-test.yml

.PHONY: build build-test clean deploy e2e-test rebuild rebuild-test

## build           | Builds the main service
build:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) build

## build-all       | Builds all docker-compose files for build, lint, and tests
build-all:
	docker-compose \
		--file $(DOCKER_COMPOSE_MAIN_FILE_NAME) \
		--file $(DOCKER_COMPOSE_LINT_FILE_NAME) \
		--file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) \
		build

## build-test      | Builds the test docker image
build-test:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) build

## clean           | Stops all docker containers running
clean:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) \
	down --remove-orphans --rmi all

## deploy          | Deploys the main service
deploy: build
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) up --detach

## e2e-test        | Runs the end to end tests
e2e-test: build-test
	# Remove the curl against the localhost PORT after we migrate this to e2e-tests
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) up --detach \
		&& curl localhost:3000/status \
		&& echo "End-to-end (E2E) tests successfully passed!" \
		|| docker-compose --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) down

## help            | Outputs the possible make commands
help : Makefile
	@sed -n 's/^##//p' $<

## lint            | Runs the linter
lint:
	docker-compose --file $(DOCKER_COMPOSE_LINT_FILE_NAME) up

## precommit       | Runs necessary build/tests before committing
precommit: rebuild-all lint e2e-test

## rebuild         | Builds the main service with no caching and pulling in the latest images
rebuild:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) build --no-cache --pull

## rebuild-all     | Builds all docker-compose files for build, lint, and tests with no caching
##                 | and pulling in the latest images
rebuild-all:
	docker-compose \
		--file $(DOCKER_COMPOSE_MAIN_FILE_NAME) \
		--file $(DOCKER_COMPOSE_LINT_FILE_NAME) \
		--file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) \
		build --no-cache --pull

## rebuild-test    | Builds the test image with no caching and pulling in the latest image
rebuild-test:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) build --no-cache --pull
