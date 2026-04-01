#!/usr/bin/env bashio
set -euo pipefail

WAIT_PIDS=()
CONFIG_PATH='/share/frpc.toml'
DEFAULT_CONFIG_PATH='/frpc.toml'
LOG_PATH='/share/frpc.log'

function stop_frpc() {
    bashio::log.info "Stopping frpc client"

    if [ "${#WAIT_PIDS[@]}" -gt 0 ]; then
        kill -15 "${WAIT_PIDS[@]}" 2>/dev/null || true
    fi
}

function ensure_config() {
    if [ -f "${CONFIG_PATH}" ]; then
        return
    fi

    bashio::log.warning "Configuration file ${CONFIG_PATH} not found, creating it from the bundled template"
    cp "${DEFAULT_CONFIG_PATH}" "${CONFIG_PATH}"
}

ensure_config
touch "${LOG_PATH}"

bashio::log.info "Starting frp client with configuration ${CONFIG_PATH}"

cd /usr/src
./frpc -c "${CONFIG_PATH}" &
FRPC_PID=$!
WAIT_PIDS+=("${FRPC_PID}")

tail -F "${LOG_PATH}" &
LOG_TAIL_PID=$!
WAIT_PIDS+=("${LOG_TAIL_PID}")

trap "stop_frpc" SIGTERM SIGHUP
wait "${FRPC_PID}"
kill -15 "${LOG_TAIL_PID}" 2>/dev/null || true
wait "${LOG_TAIL_PID}" 2>/dev/null || true
