define HELP_MESSAGE =
Make targets:

Common:

  help - Show this message and exit.

Docker commands:
  docker/build                  - Build docker images
  docker/up                     - Start docker environment in detached mode.
  docker/logs                   - Display docker environment logs.
  docker/down                   - Stop and remove containers.
  docker/run-migrations         - Run migrations in docker environment.

endef
export HELP_MESSAGE

.PHONY: help
help:
	@echo "$$HELP_MESSAGE"

# Docker commands

.PHONY: docker/build
docker/build:
	docker-compose build

.PHONY: docker/rebuild
docker/rebuild:
	docker-compose build --no-cache

.PHONY: docker/up
docker/up:
	docker-compose up --build -d

.PHONY: docker/logs
docker/logs:
	docker-compose logs -f

.PHONY: docker/down
docker/down:
	docker-compose down

.PHONY: docker/run-migrations
docker/run-migrations:
	docker-compose run --rm pulp-api manage migrate
	docker-compose run --rm galaxy-api manage migrate
