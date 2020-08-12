# Containerized Clojure Development Environment

:warning: **Warning:** :warning: I'm not a Clojure expert! I put this
environment together as a PoC.

The goal of this repo is to show how to containerize a development environment
so that one gets the benefits of a local environment, like hot reloading, with
the benefits of containerization– a development environment defined in code.

## Prerequisites

* macOS or Windows:
  * [Docker Desktop](https://www.docker.com/get-started)
  * make
* Linux:
  * [Docker](https://www.docker.com/get-started)
  * [Docker Compose](https://github.com/docker/compose)

## Development

Get started by running `make dev`:

```console
$ make dev
Once you see the message "Started server on port 3000", open your browser to http://localhost:3000
COMPOSE_DOCKER_CLI_BUILD=1 DEV_IMAGE=clojure-demo:latest docker-compose up --build
...
Starting clojure_demo_1 ... done
Attaching to clojure_demo_1
demo_1  | OpenJDK 64-Bit Server VM warning: Options -Xverify:none and -noverify were deprecated in JDK 13 and will likely be removed in a future release.
demo_1  | 2020-08-11 15:08:55.742:INFO::main: Logging initialized @16243ms
demo_1  | 2020-08-11 15:08:55.781:INFO:oejs.Server:main: jetty-9.2.10.v20150310
demo_1  | 2020-08-11 15:08:55.900:INFO:oejs.ServerConnector:main: Started ServerConnector@3741a170{HTTP/1.1}{0.0.0.0:3000}
demo_1  | 2020-08-11 15:08:55.900:INFO:oejs.Server:main: Started @16402ms
demo_1  | Started server on port 3000
```

Once you see the "Started server on port 3000", navigate to
http://localhost:3000 in a Web browser.

Open [my-webapp/src/my_webapp/views.clj](./my-webapp/src/my_webapp/views.clj) in
your favorite code editor and edit the `home-page` view. When you save the file,
your browser will automatically reload the page.

You can learn more about how this works by looking at the
[docker-compose.yaml](./docker-compose.yaml) file.

## Unit testing

To run the unit tests, simply run `make unit-test` or `make test`:

```console
$ make test
docker build --target unit-test --progress=plain .
...
#14 [unit-test 2/2] RUN lein test
#14 0.277 OpenJDK 64-Bit Server VM warning: Options -Xverify:none and -noverify were deprecated in JDK 13 and will likely be removed in a future release.
#14 10.82
#14 10.82 lein test my-webapp.handler-test
#14 10.92
#14 10.92 Ran 1 tests containing 2 assertions.
#14 10.92 0 failures, 0 errors.
#14 DONE 11.3s
...
#15 DONE 0.3s
```

The unit test code can be found in
[my-webapp/test/my_webapp](./my-webapp/test/my_webapp).

## Building a production image

To build a "production" image containing a standalone jar of the application,
you can run `make build`.


## Running the production image

To run the production image, you can run `make run`. You will then find the
application served at http://localhost:8080.

```console
$ make run
...
docker run --rm -p 8080:8080 --name myapp ccrone/clojure-demo:latest
2020-08-12 16:14:57.159:INFO::main: Logging initialized @6261ms
2020-08-12 16:14:59.128:INFO:oejs.Server:main: jetty-9.2.z-SNAPSHOT
2020-08-12 16:14:59.353:INFO:oejs.ServerConnector:main: Started ServerConnector@3ed981e1{HTTP/1.1}{0.0.0.0:8080}
2020-08-12 16:14:59.354:INFO:oejs.Server:main: Started @8456ms
```

## Learn more!

There are extensive comments in the following files:

* [Makefile](./Makefile) for aliasing commands
* [Dockerfile](./Dockerfile) for building images
* [docker-compose.yaml](./docker-compose.yaml) for the developer flow
