#!/bin/bash

# File common.sh - Chứa các hàm và utilities chung cho tất cả scripts
# Tự động xác định thư mục scripts
COMMON_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tự động load load-env.sh nếu chưa được load
if ! declare -f load_env > /dev/null; then
  if [ -f "$COMMON_SCRIPT_DIR/load-env.sh" ]; then
    source "$COMMON_SCRIPT_DIR/load-env.sh"
  else
    echo "Not found load-env.sh at: $COMMON_SCRIPT_DIR/load-env.sh"
  fi
fi

# Helper function để load .env tự động
auto_load_env() {
  local target_dir="${1:-$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)}"

  # Expand ~ nếu có
  target_dir="${target_dir/#\~/$HOME}"

  # Kiểm tra và load .env
  if [ -f "$target_dir/.env" ]; then
    echo "Loading .env from: $target_dir/.env"
    load_env "$target_dir/.env"
  else
    echo "Not found .env at: $target_dir/.env"
  fi
}
