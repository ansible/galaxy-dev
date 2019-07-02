#!/bin/bash

set -o nounset
set -o errexit

PULP_CODE="${PULP_CODE}"

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
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -n 'resource-manager@%h' \
      -c 'pulpcore.rqconfig' \
      --pid='/var/run/pulp/resource_manager.pid'
}

run_worker() {
  _prepare_env
  exec rq worker \
      -w 'pulpcore.tasking.worker.PulpWorker' \
      -n "reserved-resource-worker@%h" \
      -c 'pulpcore.rqconfig' \
      --pid="/var/run/pulp/worker.pid"
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
