#!/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
parse_args "$@"
auto_load_env "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export DEV_DB_HOST=$([ "$IS_VPN" = "true" ] && echo "100.70.254.142" || echo "10.123.31.100")
export PGPASSWORD=$PGPASSWORD_DEV PGHOST=$DEV_DB_HOST PGUSER="local_postgres_user" PGPORT=30838 PGDATABASE="aim-api"

[ "$on" = "true" ] && psql <<EOF
BEGIN; DELETE FROM public.processed_blocks WHERE chain_id = 97; UPDATE public.networks SET is_paused_scan = false WHERE chain_id = 97; COMMIT;
EOF

[ "$off" = "true" ] && psql <<EOF
BEGIN; UPDATE public.networks SET is_paused_scan = true WHERE chain_id = 97; COMMIT;
EOF
