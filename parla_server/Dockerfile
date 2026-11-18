# Build from the project root with:
# docker build -f parla_server/Dockerfile .
#
# The image holds the server and the admin panel (parla_admin, a Flutter
# web build served by the server at /admin/). Nothing in it is tied to an
# environment: the panel talks to the origin it is served from.

# Admin panel stage: Flutter from the official release archive, pinned by
# version and checksum (same version as CI).
FROM debian:bookworm-slim AS admin
ARG FLUTTER_VERSION=3.47.9
ARG FLUTTER_SHA256=25ed8c3c29d51a7353f2a944310b478af8214920639524b19c50a19e6c044c5a
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl git unzip xz-utils \
  && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL -o /tmp/flutter.tar.xz \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
  && echo "${FLUTTER_SHA256}  /tmp/flutter.tar.xz" | sha256sum -c - \
  && tar -xf /tmp/flutter.tar.xz -C /opt \
  && rm /tmp/flutter.tar.xz \
  && git config --global --add safe.directory /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"
RUN flutter config --no-analytics --no-cli-animations >/dev/null \
  && dart --disable-analytics >/dev/null

WORKDIR /app
COPY pubspec.lock .
COPY parla_shared parla_shared
COPY parla_client parla_client
COPY parla_admin parla_admin
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  "  sdk: ^3.12.2" \
  'workspace:' \
  '  - parla_shared' \
  '  - parla_client' \
  '  - parla_admin' \
  > pubspec.yaml
WORKDIR /app/parla_admin
RUN flutter pub get
# CanvasKit is bundled (no Google CDN), so the browser loads nothing from
# third parties.
RUN flutter build web --release --base-href /admin/ --no-web-resources-cdn

# Build stage
FROM dart:3.12.2 AS build

# Create a minimal workspace that preserves locked server dependency versions.
WORKDIR /app
COPY pubspec.lock .
COPY parla_shared parla_shared
COPY parla_server parla_server
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.12.2' \
  'workspace:' \
  '  - parla_shared' \
  '  - parla_server' \
  > pubspec.yaml
RUN dart pub get

# Compile the server executable.
WORKDIR /app/parla_server
RUN dart build cli --target bin/main.dart --output build
RUN mv build/bundle/bin/main build/bundle/bin/server

# Add a fallback for the copy of possibly missing directories.
RUN mkdir -p config web migrations

# Final stage
FROM alpine:latest
WORKDIR /app

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith
# Extra flags, e.g. "--apply-migrations" on the staging service.
ENV flags=""

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable and native libraries
COPY --from=build /app/parla_server/build/bundle/ ./

# Copy configuration files and resources
COPY --from=build /app/parla_server/config/ config/
COPY --from=build /app/parla_server/web/ web/
COPY --from=admin /app/parla_admin/build/web/ web/admin/
COPY --from=build /app/parla_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/parla_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ./bin/server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role $flags
