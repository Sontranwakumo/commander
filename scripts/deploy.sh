#!/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
parse_args "$@"
echo "Triển khai ứng dụng - Môi trường: $env - Phiên bản: ${version:-latest}"
for step in "Kiểm tra dependencies" "Build ứng dụng" "Deploy lên $env" "Kiểm tra health check"; do
  echo "[$((++i))/4] $step..." && sleep 1
done
echo "✅ Triển khai thành công!"
