FROM clojure:openjdk-15-lein-alpine AS base
WORKDIR /usr/src/app

FROM base AS dev
EXPOSE 3000
VOLUME ["/usr/src/app"]
CMD lein ring server-headless

FROM base AS build
COPY my-webapp/project.clj .
RUN lein deps
COPY my-webapp/resources resources
COPY my-webapp/src src
RUN lein uberjar

FROM openjdk:15-alpine AS prod
EXPOSE 8080
COPY --from=build /usr/src/app/target/my-webapp-0.1.0-standalone.jar .
CMD java -jar my-webapp-0.1.0-standalone.jar 8080
