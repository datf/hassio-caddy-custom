#!/command/with-contenv bashio

declare -a args=()

bashio::log.info 'Prepare Caddy...'

CUSTOM_CADDYFILE_PATH="/config/Caddyfile"

if bashio::fs.file_exists "${CUSTOM_CADDYFILE_PATH}"; then
  bashio::log.info "Caddyfile found at ${CUSTOM_CADDYFILE_PATH}"
  export CONFIG_PATH=${CUSTOM_CADDYFILE_PATH}
else
  bashio::log.info "No Caddyfile found. Using default."
  export CONFIG_PATH=/etc/caddy/Caddyfile
fi

CUSTOM_CADDY_PATH="/config/caddy-custom"

# Check for custom Caddy binary at custom Caddy path
bashio::log.info "Checking path: ${CUSTOM_CADDY_PATH}"
if bashio::fs.file_exists "${CUSTOM_CADDY_PATH}"; then
  bashio::log.info "Found custom Caddy with modules:"
  "${CUSTOM_CADDY_PATH}" list-modules -s
  export CADDY_PATH="${CUSTOM_CADDY_PATH}"
else
  bashio::log.info "Using vanilla Caddy"
  export CADDY_PATH="/app/caddy"
fi

bashio::log.info $("${CADDY_PATH}" version)

bashio::log.info "Runing Caddy..."
bashio::log.debug "'${CADDY_PATH}' run --config '${CONFIG_PATH}' '${args[*]}'"
"${CADDY_PATH}" run --config "${CONFIG_PATH}" "${args[@]}"
