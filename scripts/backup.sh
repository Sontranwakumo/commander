#!/bin/bash

# Script sao lưu dữ liệu
# Sử dụng: ./backup.sh source="path/to/source" destination="path/to/dest"

# Parse arguments
for arg in "$@"; do
  key=$(echo $arg | cut -d'=' -f1)
  value=$(echo $arg | cut -d'=' -f2 | tr -d '"')
  eval "$key=$value"
done

# Validate source
if [ -z "$source" ]; then
  echo "Lỗi: Thư mục nguồn không được để trống"
  exit 1
fi

if [ ! -d "$source" ]; then
  echo "Lỗi: Thư mục nguồn không tồn tại: $source"
  exit 1
fi

# Default destination
destination=${destination:-"./backups"}

# Tạo thư mục đích nếu chưa tồn tại
mkdir -p "$destination"

# Tạo tên file backup với timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")
backup_name="backup_$(basename $source)_${timestamp}.tar.gz"

echo "Đang sao lưu từ $source đến $destination/$backup_name..."
tar -czf "$destination/$backup_name" -C "$(dirname $source)" "$(basename $source)"

if [ $? -eq 0 ]; then
  echo "Sao lưu thành công: $destination/$backup_name"
else
  echo "Lỗi khi thực hiện sao lưu"
  exit 1
fi
