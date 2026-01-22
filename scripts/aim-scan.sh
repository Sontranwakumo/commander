#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# PROJECT_DIR là thư mục cha của scripts (thư mục commander)
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/common.sh"

for arg in "$@"; do
  if [[ "$arg" == *"="* ]]; then
    # Flag có value (key="value")
    key=$(echo $arg | cut -d'=' -f1)
    value=$(echo $arg | cut -d'=' -f2 | tr -d '"')
    eval "$key=$value"
  else
    # Boolean flag (chỉ có tên flag)
    eval "$arg=true"
  fi
done

auto_load_env "$PROJECT_DIR"

IS_VPN=false
if [ "$IS_VPN" = true ]; then
  export DEV_DB_HOST="100.70.254.142"
else
  export DEV_DB_HOST="10.123.31.100"
fi

export PGPASSWORD=$PGPASSWORD_DEV
export PGHOST=$DEV_DB_HOST
export PGUSER="local_postgres_user"
export PGPORT=30838
export PGDATABASE="aim-api"

turnOnAimScan() {
  psql <<EOF
BEGIN;
DELETE FROM public.processed_blocks WHERE chain_id = 97;
UPDATE public.networks SET is_paused_scan = false WHERE chain_id = 97;
COMMIT;
EOF

}

turnOffAimScan() {
  psql <<EOF
BEGIN;
UPDATE public.networks SET is_paused_scan = true WHERE chain_id = 97;
COMMIT;
EOF
}

# Xử lý logic scan
if [ "$on" = "true" ]; then
  turnOnAimScan
elif [ "$off" = "true" ]; then
  turnOffAimScan
fi
