# Stage 1: Build Flutter Web
FROM ubuntu:22.04 AS build-env

RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa
WORKDIR /app
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH="/app/flutter/bin:/app/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-fetch dependencies
COPY frontend/pubspec.* /app/frontend/
WORKDIR /app/frontend
RUN flutter pub get

COPY frontend /app/frontend
RUN flutter build web --release

# Stage 2: Build Dart Server
FROM dart:stable AS build-server
WORKDIR /app/server

COPY server/pubspec.* ./
RUN dart pub get

COPY server .
RUN dart compile exe bin/server.dart -o bin/server

# Stage 3: Package into minimal runner
FROM debian:bookworm-slim

# The Dart sqlite3 package requires libsqlite3-dev dynamic objects
RUN apt-get update && apt-get install -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Copy Flutter compiled web output
COPY --from=build-env /app/frontend/build/web /app/web

# Copy Dart compiled binary
COPY --from=build-server /app/server/bin/server /app/server

# Setup environment variables for Dart server to consume natively
ENV WEB_DIR="/app/web"
ENV DATA_DIR="/data"
ENV PORT="8080"

# Expose persistence volume mapping for Compute Engine
VOLUME ["/data"]

EXPOSE 8080
CMD ["/app/server"]
