export DOCKER_BUILDKIT=1

.PHONY: dev
dev:
	open http://localhost:3000 && COMPOSE_DOCKER_CLI_BUILD=1 docker-compose up --build

.PHONY: build
build:
	docker build --target prod --tag myapp .

.PHONY: run
run: build
	docker run --rm -p 8080:8080 --name myapp myapp

.PHONY: clean
clean:
	docker-compose down
