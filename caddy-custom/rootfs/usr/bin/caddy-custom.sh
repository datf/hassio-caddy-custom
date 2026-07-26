#!/command/with-contenv bashio

declare -a args=()

bashio::log.info 'Prepare Caddy...'

CUSTOM_CADDYFILE_PATH="${XDG_CONFIG_HOME}/Caddyfile"

if bashio::fs.file_exists "${CUSTOM_CADDYFILE_PATH}"; then
  bashio::log.info "Caddyfile found at ${CUSTOM_CADDYFILE_PATH}"
  export CONFIG_PATH=${CUSTOM_CADDYFILE_PATH}
else
  bashio::log.info "No Caddyfile found at ${CUSTOM_CADDYFILE_PATH}. Using default."
  export CONFIG_PATH=/etc/caddy/Caddyfile
fi

CUSTOM_CADDY_PATH="${XDG_CONFIG_HOME}/caddy-custom"

# Check for custom Caddy binary at custom Caddy path
bashio::log.info "Checking path: ${CUSTOM_CADDY_PATH}"
if bashio::fs.file_exists "${CUSTOM_CADDY_PATH}"; then
  bashio::log.info "Found custom Caddy with modules:"
  "${CUSTOM_CADDY_PATH}" list-modules -s
  if bashio::fs.file_exists "/tmp/caddy_hotswap"; then
      bashio::log.info "Hot-swap flag detected. Removing..."
      rm -f /tmp/caddy_hotswap
      exit 0
  fi
  export CADDY_PATH="${CUSTOM_CADDY_PATH}"
else
  bashio::log.info "Using vanilla Caddy"
  export CADDY_PATH="/app/caddy"
fi

bashio::log.info $("${CADDY_PATH}" version)

bashio::log.info "Runing Caddy..."
bashio::log.debug "'${CADDY_PATH}' run --config '${CONFIG_PATH}' '${args[*]}'"
exec "${CADDY_PATH}" run --config "${CONFIG_PATH}" "${args[@]}"
