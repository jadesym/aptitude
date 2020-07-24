# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

DOCKER_COMPOSE_MAIN_FILE_NAME = docker-compose.yml
DOCKER_COMPOSE_BUILD_FILE_NAME = docker-compose.build.yml
DOCKER_COMPOSE_E2E_TEST_FILE_NAME = docker-compose.e2e-test.yml

.PHONY: build build-test clean deploy e2e-test rebuild rebuild-test

build:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) build

build-all:
	docker-compose \
		--file $(DOCKER_COMPOSE_MAIN_FILE_NAME) \
		--file $(DOCKER_COMPOSE_BUILD_FILE_NAME) \
		--file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) \
		build

build-test:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) build

clean:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) \
	down --remove-orphans --rmi all

deploy: build
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) up --detach

e2e-test: build-test
	# Remove the curl against the localhost PORT after we migrate this to e2e-tests
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) up --detach \
		&& curl localhost:3000/status \
		&& echo "End-to-end (E2E) tests successfully passed!" \
		|| docker-compose --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) down

lint:
	docker-compose --file $(DOCKER_COMPOSE_BUILD_FILE_NAME) run lint

precommit: rebuild-all lint e2e-test

rebuild:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) build --no-cache --pull

rebuild-all:
	docker-compose \
		--file $(DOCKER_COMPOSE_MAIN_FILE_NAME) \
		--file $(DOCKER_COMPOSE_BUILD_FILE_NAME) \
		--file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) \
		build --no-cache --pull

rebuild-test:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_E2E_TEST_FILE_NAME) build --no-cache --pull
