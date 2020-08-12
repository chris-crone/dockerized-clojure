# BuildKit is a next generation container image builder. You can enable it using
# an environment variable or using the Engine config, see:
# https://docs.docker.com/develop/develop-images/build_enhancements/#to-enable-buildkit-builds
export DOCKER_BUILDKIT=1

GIT_TAG?=$(shell git describe --tags --match "v[0-9]*" 2> /dev/null)
ifeq ($(GIT_TAG),)
	GIT_TAG=latest
endif

# Docker image tagging:
HUB_USER?=ccrone
REPO?=clojure-demo
TAG?=${GIT_TAG}
DEV_IMAGE?=${REPO}:latest
PROD_IMAGE?=${HUB_USER}/${REPO}:${TAG}

all: dev

# Local development happens here!
# This starts your application and bind mounts the source into the container so
# that changes are reflected in real time.
# Once you see the message "Started server on port 3000", open a Web browser at
# http://localhost:3000
.PHONY: dev
dev:
	@echo "Once you see the message \"Started server on port 3000\", open your browser to http://localhost:3000"
	COMPOSE_DOCKER_CLI_BUILD=1 DEV_IMAGE=${DEV_IMAGE} docker-compose up --build

# Run the unit tests.
# Note that we use plain progress here to see the test results more easily.
.PHONY: unit-test test
unit-test:
	docker build --target unit-test --progress=plain .

test: unit-test

# Build a production image for the application.
.PHONY: build
build:
	docker build --target prod --tag ${PROD_IMAGE} .

# Push the production image to a registry.
.PHONY: push
push: build
	docker push ${PROD_IMAGE}

# Run the application locally.
# Once the application has started, you can find it on http://localhost:8080
.PHONY: deploy run
deploy: build
	docker run --rm -p 8080:8080 --name myapp ${PROD_IMAGE}

run: deploy

# Remove the dev container, dev image, and clear the builder cache.
.PHONY: clean
clean:
	@docker-compose down
	@docker rmi ${DEV_IMAGE}
	@docker builder prune --force --filter type=exec.cachemount --filter=unused-for=24h
