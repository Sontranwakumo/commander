#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load env từ file load-env.sh trong cùng thư mục
if [ -f "$SCRIPT_DIR/load-env.sh" ]; then
  source "$SCRIPT_DIR/load-env.sh"
else
  echo "Cảnh báo: Không tìm thấy file load-env.sh trong $SCRIPT_DIR"
fi

# Parse arguments - xử lý cả boolean flags và flags có value
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

turnOnAimScan() {

}

turnOffAimScan() {
  echo "Đang tắt scan AIM..."
  # Thêm logic tắt scan ở đây
  echo "✅ Scan đã được tắt"
}

# Xử lý logic scan
if [ "$on" = "true" ]; then
  turnOnAimScan
elif [ "$off" = "true" ]; then
  turnOffAimScan
fi
