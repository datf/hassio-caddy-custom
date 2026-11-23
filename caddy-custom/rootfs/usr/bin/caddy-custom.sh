#!/command/with-contenv bashio
# shellcheck shell=bash

# Remove any stale hot-swap flag from a previous interrupted restart
rm -f /tmp/caddy_hotswap

ARGS=()
if bashio::config.has_value 'args'; then
  readarray -t RAW_ARGS < <(bashio::config 'args')
  for arg in "${RAW_ARGS[@]}"; do
    bashio::var.has_value "${arg}" && ARGS+=("${arg}")
  done
fi
bashio::log.debug "args from config: '${ARGS[*]}'"

bashio::log.debug 'Prepare Caddy...'

# Export environment variables first so validation and Caddy runtime have them
if bashio::config.has_value 'env_vars'; then
  for var in $(bashio::config 'env_vars|keys'); do
    export "$(bashio::config "env_vars[${var}].name")"="$(bashio::config "env_vars[${var}].value")"
  done
fi

CUSTOM_CADDYFILE_PATH="${XDG_CONFIG_HOME}/Caddyfile"
BUILTIN_CADDYFILE_PATH="/etc/caddy/Caddyfile"

if bashio::fs.file_exists "${CUSTOM_CADDYFILE_PATH}"; then
  bashio::log.debug "Caddyfile found at ${CUSTOM_CADDYFILE_PATH}"
  CONFIG_PATH="${CUSTOM_CADDYFILE_PATH}"
else
  bashio::log.debug "No Caddyfile found at ${CUSTOM_CADDYFILE_PATH}. Using built-in."
  CONFIG_PATH="${BUILTIN_CADDYFILE_PATH}"
fi

CUSTOM_CADDY_PATH="${XDG_CONFIG_HOME}/caddy-custom"

# Check for custom Caddy binary at custom Caddy path
bashio::log.debug "Checking path: ${CUSTOM_CADDY_PATH}"
if bashio::fs.file_exists "${CUSTOM_CADDY_PATH}"; then
  bashio::log.info "Found custom Caddy with modules:"
  "${CUSTOM_CADDY_PATH}" list-modules -s
  CADDY_PATH="${CUSTOM_CADDY_PATH}"
else
  bashio::log.info "Using vanilla Caddy"
  CADDY_PATH="/app/caddy"
fi

"${CADDY_PATH}" version

# Validate configuration before running
bashio::log.debug "Validating config '${CONFIG_PATH}' with '${CADDY_PATH}'..."
VALIDATION_OUTPUT=""
if VALIDATION_OUTPUT=$("${CADDY_PATH}" validate --config "${CONFIG_PATH}" 2>&1); then
  bashio::log.info "Configuration valid. Running Caddy..."
  bashio::log.debug "'${CADDY_PATH}' run --config '${CONFIG_PATH}' '${ARGS[*]}'"
  exec "${CADDY_PATH}" run --config "${CONFIG_PATH}" "${ARGS[@]}"
else
  bashio::log.warning "Caddyfile at '${CONFIG_PATH}' failed validation with current Caddy binary."
  bashio::log.warning "Validation error: ${VALIDATION_OUTPUT}"

  AUTOSAVE_PATH="${XDG_CONFIG_HOME}/caddy/autosave.json"
  if bashio::fs.file_exists "${AUTOSAVE_PATH}"; then
    bashio::log.warning "Falling back to last successful configuration using --resume..."
    # Filter out --watch/-w (and --config/-c) from ARGS since --watch cannot be combined with --resume
    RESUME_ARGS=()
    skip_next=false
    for arg in "${ARGS[@]}"; do
      if [ "${skip_next}" = true ]; then
        skip_next=false
        continue
      fi
      case "${arg}" in
        --watch|-w)
          continue
          ;;
        --config|-c)
          skip_next=true
          continue
          ;;
        --config=*)
          continue
          ;;
        *)
          RESUME_ARGS+=("${arg}")
          ;;
      esac
    done
    bashio::log.info "Running Caddy with --resume..."
    exec "${CADDY_PATH}" run --resume "${RESUME_ARGS[@]}"
  elif [ "${CONFIG_PATH}" != "${BUILTIN_CADDYFILE_PATH}" ] && bashio::fs.file_exists "${BUILTIN_CADDYFILE_PATH}"; then
    bashio::log.warning "No autosave.json found. Falling back to built-in default config..."
    bashio::log.info "Running Caddy with built-in Caddyfile..."
    exec "${CADDY_PATH}" run --config "${BUILTIN_CADDYFILE_PATH}" "${ARGS[@]}"
  else
    bashio::log.error "Unable to start Caddy: configuration invalid and no fallback available."
    exit 1
  fi
fi
