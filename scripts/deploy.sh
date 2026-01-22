#!/bin/bash

# Script triển khai ứng dụng
# Sử dụng: ./deploy.sh env="prod" version="1.0.0"

# Parse arguments
for arg in "$@"; do
  key=$(echo $arg | cut -d'=' -f1)
  value=$(echo $arg | cut -d'=' -f2 | tr -d '"')
  eval "$key=$value"
done

# Validate environment
if [ -z "$env" ]; then
  echo "Lỗi: Môi trường không được để trống"
  exit 1
fi

if [[ ! "$env" =~ ^(dev|staging|prod)$ ]]; then
  echo "Lỗi: Môi trường không hợp lệ. Chỉ chấp nhận: dev, staging, prod"
  exit 1
fi

version=${version:-"latest"}

echo "========================================="
echo "Triển khai ứng dụng"
echo "Môi trường: $env"
echo "Phiên bản: $version"
echo "========================================="

# Mô phỏng quá trình deploy
echo "[1/4] Đang kiểm tra dependencies..."
sleep 1

echo "[2/4] Đang build ứng dụng..."
sleep 1

echo "[3/4] Đang deploy lên môi trường $env..."
sleep 1

echo "[4/4] Đang kiểm tra health check..."
sleep 1

echo "✅ Triển khai thành công!"
