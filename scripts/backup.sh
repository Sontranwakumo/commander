#!/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
parse_args "$@"
mkdir -p "${destination:-./backups}"
tar -czf "${destination:-./backups}/backup_$(basename $source)_$(date +%Y%m%d_%H%M%S).tar.gz" -C "$(dirname $source)" "$(basename $source)"
