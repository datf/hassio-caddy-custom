ARG BUILD_FROM=ghcr.io/home-assistant/base:latest
FROM $BUILD_FROM

ENV LANG=C.UTF-8

RUN apk add --no-cache go nss-tools

RUN mkdir /app

ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$PATH

# Paths for caddy config and certificates
ENV XDG_CONFIG_HOME=/data
ENV XDG_DATA_HOME=/ssl

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build --output /app/caddy --with github.com/fabriziosalmi/caddy-waf --with github.com/mkalus/caddy_nobots_v2

RUN /app/caddy version; /app/caddy build-info

COPY rootfs /

LABEL \
    io.hass.type="addon" \
    org.opencontainers.image.title="Home Assistant App: Caddy Custom" \
    org.opencontainers.image.description="Caddy with compiled add-ons" \
    org.opencontainers.image.source="https://github.com/datf/hassio-caddy-custom" \
    org.opencontainers.image.licenses="MIT"
