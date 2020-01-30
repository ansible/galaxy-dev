#!/bin/bash

# NOTE: This line should be before setting bash modes, because
# `scl_source` is not compatible with `set -o nounset`.
ENABLED_COLLECTIONS="${ENABLED_COLLECTIONS:-}"
if [[ ! -z "${ENABLED_COLLECTIONS}" ]]; then
  source scl_source enable ${ENABLED_COLLECTIONS}
fi


set -o nounset
set -o errexit


PULP_CODE="${PULP_CODE}"
PULP_VENV="${PULP_VENV}"


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
  VIRTUAL_ENV_DISABLE_PROMPT=1 \
    source "${PULP_VENV}/bin/activate"
  pip install --no-cache-dir -e "${PULP_CODE}/pulp_ansible"
  _wait_for_tcp_port postgres 5432
  _wait_for_tcp_port redis 6379
}

run_service() {
  case "$1" in
    'api')
      run_api
      ;;
    'resource-manager')
      run_resource_manager
      ;;
    'worker')
      run_worker
      ;;
    'content-app')
      run_content_app
      ;;
    *)
      echo 'Invalid command'
      exit 1
  esac
}

run_api() {
  _prepare_env
  exec django-admin runserver '0.0.0.0:8000'
}

run_resource_manager() {
  _prepare_env
  exec rq worker \
      -n 'resource-manager' \
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -c 'pulpcore.rqconfig'
}

run_worker() {
  if [ "$(ls ${PULP_CODE}/importer-plugins)" ]; then
      pip install --no-cache-dir "${PULP_CODE}"/importer-plugins/*.whl
  fi
  _prepare_env
  exec rq worker \
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -c 'pulpcore.rqconfig'
}

run_content_app() {
  _prepare_env
  exec pulp-content
}

manage() {
  _prepare_env
  exec django-admin "$@"
}

main() {
  case "$1" in
    'run')
      run_service "${@:2}"
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
