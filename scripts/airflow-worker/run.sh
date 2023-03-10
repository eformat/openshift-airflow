#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Airflow environment variables
. /opt/app-root/scripts/airflow-worker/airflow-worker-env.sh

# Load libraries
. /opt/app-root/scripts/common/libos.sh
. /opt/app-root/scripts/airflow-worker/libairflowworker.sh

EXEC="${AIRFLOW_BIN_DIR}/airflow"
args=("celery" "worker")
if [[ -n "$AIRFLOW_QUEUE" ]]; then
    args+=("-q" "$AIRFLOW_QUEUE")
fi
args+=("--pid" "$AIRFLOW_PID_FILE" "$@")

info "** Starting Airflow **"
if am_i_root; then
    exec gosu "$AIRFLOW_DAEMON_USER" "$EXEC" "${args[@]}"
else
    exec "$EXEC" "${args[@]}"
fi
