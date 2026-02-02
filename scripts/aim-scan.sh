#!/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
parse_args "$@"
auto_load_env "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ "$env" = "dev" ]; then
  export DEV_DB_HOST=$([ "$IS_VPN" = "true" ] && echo "100.70.254.142" || echo "10.123.31.100")
  export PGPASSWORD=$PGPASSWORD_DEV
  export PGHOST=$DEV_DB_HOST
  export PGUSER="local_postgres_user"
  export PGPORT=30838
  export PGDATABASE="aim-api"
elif [ "$env" = "local" ]; then
  export PGPASSWORD='dhruv314'
  export PGHOST=localhost
  export PGUSER="postgres"
  export PGPORT=5432
  export PGDATABASE="aim_api"
fi
echo "Using $env database, DBHost: $PGHOST"

if [ "$on" = "true" ]; then
  psql <<SQL
BEGIN;
DELETE FROM public.processed_blocks WHERE chain_id = 97;
UPDATE public.networks SET is_paused_scan = false WHERE chain_id = 97;
COMMIT;
SQL
  echo "AIM scan enabled"
  psql <<SQL
SELECT chain_id, is_paused_scan FROM public.networks WHERE chain_id = 97;
SQL
fi

if [ "$off" = "true" ]; then
  psql <<SQL
BEGIN;
UPDATE public.networks SET is_paused_scan = true WHERE chain_id = 97;
COMMIT;
SQL
  echo "AIM scan disabled"
  psql <<SQL
SELECT chain_id, is_paused_scan FROM public.networks WHERE chain_id = 97;
SQL
fi

if [ "$view" = "true" ]; then
  result=$(psql -t -A -c "SELECT chain_id, is_paused_scan FROM public.networks WHERE chain_id = 97")
  if [ -n "$result" ]; then
    IFS='|' read -r chain_id is_paused_scan <<< "$result"
    status=$([ "$is_paused_scan" = "t" ] && echo "paused" || echo "running")
    echo "AIM scan (chain_id=$chain_id): $status"
  else
    echo "No record found for chain_id=97"
  fi
fi

exit 0
