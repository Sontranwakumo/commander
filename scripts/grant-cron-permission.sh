#!/bin/bash
# Mở màn hình Full Disk Access để bạn thêm Terminal (giúp cron chạy đúng trên macOS).
# Chạy: ./scripts/grant-cron-permission.sh
# Sau khi mở: bấm "+" và chọn Terminal (hoặc iTerm), bật toggle.
echo "Đang mở System Settings → Privacy & Security → Full Disk Access..."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
echo ""
echo "→ Bấm '+' và chọn Terminal (hoặc iTerm nếu bạn dùng)."
echo "→ Bật toggle bên cạnh ứng dụng."
echo "→ Có thể cần đăng xuất/đăng nhập lại hoặc khởi động lại Terminal."
