ARG BUILD_FROM=ghcr.io/hassio-addons/base:21.0.11
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ENV LANG=C.UTF-8

RUN mkdir /app

ENV GOPATH=/go \
    GOTOOLCHAIN=local \
    PATH="/go/bin:/usr/local/go/bin:${PATH}" \
    XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/ssl

# Copy Go directly from the official multi-arch Alpine image
# hadolint ignore=DL3022
COPY --from=docker.io/library/golang:1.27.4-alpine /usr/local/go /usr/local/go

# Copy xcaddy from the official caddy-builder image
# hadolint ignore=DL3022
COPY --from=docker.io/library/caddy:2.11.9-builder-alpine /usr/bin/xcaddy /usr/bin/xcaddy

RUN mkdir -p "${GOPATH}/src" "${GOPATH}/bin" \
    && chmod -R 1777 "${GOPATH}" \
    && apk add --no-cache \
        nss-tools=3.133-r0

COPY rootfs /

ENV CADDY_VERSION="v2.11.9"

RUN xcaddy build ${CADDY_VERSION} --output /app/caddy; \
    /app/caddy version; /app/caddy build-info

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
