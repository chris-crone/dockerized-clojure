# The base stage is reused by a couple of the other stages.
# It includes downloading the project's dependencies.
# You can build any one of these stages by specifying the "--target" flag when
# running docker build.
FROM clojure:openjdk-15-lein-alpine AS base
WORKDIR /usr/src/app
COPY my-webapp/project.clj .
RUN lein deps

# The dev stage is used to build the hot reload image.
# Note that we specify a volume where the source is mounted.
# You can see how this is run by looking at the docker-compose.yaml
FROM base AS dev
EXPOSE 3000
VOLUME ["/usr/src/app"]
CMD lein ring server-headless

# The src stage contains all the source needed for the project and is used by
# other stages.
FROM base AS src
COPY my-webapp/project.clj .
RUN lein deps
COPY my-webapp/resources resources
COPY my-webapp/src src

# The unit-test stage runs the project's unit tests.
FROM src AS unit-test
COPY my-webapp/test test
RUN lein test

# The build stage builds a standalone jar of the project.
FROM src AS build
RUN lein uberjar

# The prod stage is the "production" image.
# It includes only the Java runtime and the the standalone jar of the
# application.
FROM openjdk:15-alpine AS prod
WORKDIR /usr/src/app
EXPOSE 8080
COPY --from=build /usr/src/app/target/my-webapp-0.1.0-standalone.jar ./target/
CMD java -jar ./target/my-webapp-0.1.0-standalone.jar 8080
