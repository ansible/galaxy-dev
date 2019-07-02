#!/bin/bash

set -o nounset
set -o errexit

GALAXY_CODE="${GALAXY_CODE}"

_wait_for_tcp_port() {
  local -r host="$1"
  local -r port="$2"

  local attempts=6
  local timeout=1

  echo "[debug]: Waiting for port tcp://${host}:${port}"
  while [ $attempts -gt 0 ]; do
    timeout 1 /bin/bash -c ">/dev/tcp/${host}/${port}" &>/dev/null && return 0 || :

    echo "[debug]: Waiting ${timeout} seconds more..."
    sleep $timeout

    timeout=$(( $timeout * 2 ))
    attempts=$(( $attempts - 1 ))
  done

  echo "[error]: Port tcp://${host}:${port} is not available"
  return 1
}

_prepare_env() {
  pip install -e "${GALAXY_CODE}/galaxy-api"
  _wait_for_tcp_port postgres 5432
}

run() {
  _prepare_env
  exec django-admin runserver "0.0.0.0:8000"
}

manage() {
  _prepare_env
  exec django-admin "$@"
}

main() {
  case "$1" in
    'run')
      run
      ;;
    'manage')
      manage "${@:2}"
      ;;
    *)
      exec "$@"
      ;;
    esac
}

main "$@"
