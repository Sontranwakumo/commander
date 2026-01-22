#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load-env.sh"

parse_args() {
  for arg in "$@"; do
    [[ "$arg" == *"="* ]] && eval "${arg/=/=\"}\"" || eval "$arg=true"
  done
}

auto_load_env() {
  load_env "${1:-$SCRIPT_DIR/..}/.env"
}
