# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

DOCKER_COMPOSE_MAIN_FILE_NAME = docker-compose.yml
DOCKER_COMPOSE_TEST_FILE_NAME = docker-compose.test.yml

.PHONY: build build-test clean e2e-test rebuild rebuild-test

build:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) build

build-test:
	docker-compose --file $(DOCKER_COMPOSE_TEST_FILE_NAME) build

clean:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) --file $(DOCKER_COMPOSE_TEST_FILE_NAME) \
	down --remove-orphans --rmi all

e2e-test:
	docker-compose --file $(DOCKER_COMPOSE_TEST_FILE_NAME) run e2e-test \
		&& curl localhost:3000/status \
		&& echo "End-to-end (E2E) tests successfully passed!" \
		|| docker-compose --file $(DOCKER_COMPOSE_TEST_FILE_NAME) down

rebuild:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) build --no-cache --pull

rebuild-test:
	docker-compose --file $(DOCKER_COMPOSE_TEST_FILE_NAME) build --no-cache --pull

deploy:
	docker-compose --file $(DOCKER_COMPOSE_MAIN_FILE_NAME) up --detach
