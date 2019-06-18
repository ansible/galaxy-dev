#!/bin/bash

set -o nounset
set -o errexit

readonly VENV_DIR="${GALAXY_VENV}"
readonly CODE_DIR="${GALAXY_CODE}"
readonly PROJECTS=(
    'galaxy-common'
    'galaxy-importer'
    'galaxy-worker'
    'galaxy-api'
)

# shellcheck disable=SC2034
VIRTUAL_ENV_DISABLE_PROMPT=1
# shellcheck disable=SC1090
source "${VENV_DIR}/bin/activate"

_prepare() {
    for proj in "${PROJECTS[@]}"; do
        pushd "/${CODE_DIR}/$proj" >/dev/null
        pipenv install
        pip install -e .
        popd >/dev/null
    done
}

run_api() {
    exec galaxy-manage runserver '0.0.0.0:5000'
}

run_scheduler() {
    exec celery -A galaxy_worker.app worker beat --loglevel INFO
}

run_worker() {
    exec celery -A galaxy_worker.app worker --loglevel INFO
}

run_service() {
    case $1 in
        'api')
            run_api
        ;;
        'scheduler')
            run_scheduler
        ;;
        'worker')
            run_worker
        ;;
        *)
            echo "Invalid command"
            exit 1
        ;;
    esac
}

main() {
    case "$1" in
        'run')
            _prepare
            run_service "${@:2}"
        ;;
        'manage')
            exec "${VENV_DIR}/bin/galaxy-manage" "${@:2}"
        ;;
        *)
            exec "$@"
        ;;
    esac
}

main "$@"
