ARG BUILD_FROM=ghcr.io/hassio-addons/base:21.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ENV LANG=C.UTF-8
ENV GOPATH=/go
ENV PATH=${GOPATH}/bin:${PATH}

RUN mkdir /app

COPY rootfs /

RUN apk add --no-cache \
    go=1.26.3-r0 \
    nss-tools=3.124-r0

# Paths for caddy config and certificates
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/ssl

ENV XCADDY_VERSION="v0.4.5"
ENV CADDY_VERSION="v2.11.4"

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@${XCADDY_VERSION}; \
    xcaddy build ${CADDY_VERSION} --output /app/caddy; \
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
