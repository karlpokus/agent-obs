# Build OpenLIT CLI from source
FROM golang:1.25-alpine AS openlit-builder

RUN apk add --no-cache git

RUN git clone --depth 1 \
    https://github.com/openlit/openlit.git /src/openlit

WORKDIR /src/openlit/cli

RUN CGO_ENABLED=0 go build \
    -trimpath \
    -ldflags="-s -w" \
    -o /openlit \
    ./cmd/openlit

# OpenCode runtime
FROM ghcr.io/anomalyco/opencode:1.18.31

COPY --from=openlit-builder /openlit /usr/local/bin/openlit

# Patch OpenCode Web v1 requiring xdg-open
RUN printf '#!/bin/sh\nexit 0\n' > /usr/local/bin/xdg-open \
    && chmod +x /usr/local/bin/xdg-open
